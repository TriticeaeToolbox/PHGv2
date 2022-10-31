#! /usr/bin/perl
#

#get class (winter, summer, hard, soft, etc) from database for each accession in VCF file

use strict;
use warnings;

use Getopt::Std;
use CXGN::DB::InsertDBH;
use SGN::Model::Cvterm;
use Bio::Chado::Schema;

our ($opt_H, $opt_D);

getopts('H:D:');

my $dbhost = $opt_H;
my $dbname = $opt_D;

my $count;
my $accn;
my $name;
my $val;
my $id;
my $h;
my @line;
my @row;
my $key;
my @lineA;
my %nameList;
my %accnList;
my %accn2List;
my %synList;
my %syn2List;
my %marketList;
my %accnListPhg;
my %accnHapmapList;

my $dbh = CXGN::DB::InsertDBH->new({
    dbhost   => $dbhost,
    dbname   => $dbname
});
print STDERR "Connected to database $dbname on host $dbhost.\n";
my ($query, $sth);

my $driver = "SQLite";
my $database = "/home/production/phg/phgWC400v2.1.db";
my $dsn = "dbi:$driver:dbname=$database";
my $userid = "sqlite";
my $password = "sqlite";
my $dbh2 = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
   or die $DBI::errstr;

print "Opened database successfully\n";

my $schema = Bio::Chado::Schema->connect( sub { $dbh->get_actual_dbh() } );
my $synonym_type_id = SGN::Model::Cvterm->get_cvterm_row($schema, 'stock_synonym', 'stock_property')->cvterm_id();
my $accession_type_id = SGN::Model::Cvterm->get_cvterm_row($schema, 'accession', 'stock_type')->cvterm_id();
my $accession_number_type_id = SGN::Model::Cvterm->get_cvterm_row($schema, 'accession number', 'stock_property')->cvterm_id();

#get accesions from 2019 hapmap 
$count = 0;
my $file2 = "/home/production/phg/2019_hapmap.vcf";
open(FH, '<', $file2) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @lineA = split /\t/, $_;
        foreach $key (keys @lineA) {
            if ($key > 8) {
                $count++;
                $name = uc($lineA[$key]);
                chomp($name);
		if (defined($accnHapmapList{$name})) {
		    print "duplicate $name\n";
		    $name = $name . "_C1";
		    $accnHapmapList{$name} = 1;
		} else {
                    $accnHapmapList{$name} = 1;
	        }
	    }
	}
	last;
    }
}
print "$count from hapmap file\n";

#get accessions from breedbase
$count = 0;
$query = "SELECT stock.uniquename, stockprop.value FROM stock JOIN stockprop USING(stock_id) WHERE stock.type_id=$accession_type_id AND stockprop.type_id=$accession_number_type_id ORDER BY stockprop.value;";
$query = "SELECT stock.uniquename, stock.stock_id, stockprop.value FROM stock JOIN stockprop USING(stock_id)";
$h = $dbh->prepare($query);
$h->execute();
while (($name, $id, $val) = $h->fetchrow_array()) {
    $name = uc($name);
    $val = uc($val);
    $name =~ s/\s//g;
    $val =~ s/\s//g;
    $accnList{$name} = $id;
    $accn2List{$val} = $id;
    #print "accn $name $val\n";
    $count++;
}
print "$count from stock accession\n";

#get synonyms from breedbase
$count = 0;
$query = "SELECT stock.uniquename, stock.stock_id, stockprop.value FROM stock JOIN stockprop USING(stock_id) WHERE stock.type_id=$accession_type_id AND stockprop.type_id=$synonym_type_id ORDER BY stockprop.value;";
$h = $dbh->prepare($query);
$h->execute();
while (($name, $val) = $h->fetchrow_array()) {
    $name = uc($name);
    $val = uc($val);
    $synList{$val} = $name;
    #print "synonym $name $val\n";
    $count++;
}
print "$count from stock synonym\n";

$count = 0;
foreach $key (keys %accnHapmapList) {
    if ($accnList{$key}) {
        $count++;
    } elsif ($accn2List{$key}) {
	$count++;
    } elsif ($synList{$key}) {
	$count++;
    } elsif ($syn2List{$key}) {
	$count++;
    } else {
	print "$key not found\n";
    }
}
print "$count matches from PHG\n";

sub find_market_class {
# look for Color(Red, White), Hardness, Growth habit
# allele name Red/White, Hard/Soft, Sprint/Winter/Faculative
    my ($name, $id) = @_;
    my $locus_id_color = 174;
    my $locus_id_hardness = 181;
    my $locus_id_growth = 102;
    my $class = "";
    $query = "SELECT allele_name from phenome.stock_allele, phenome.allele
  WHERE phenome.stock_allele.allele_id = phenome.allele.allele_id
  AND stock_id = $id 
  AND locus_id in (174, 181, 102)
  order by locus_id";
    $h = $dbh->prepare($query);
    $h->execute();
    while (($id) = $h->fetchrow_array()) {
      if ($class eq "") {
         $class = $id;
      } else {
         $class .= " $id";
      }
    }
    return $class;
}

$count = 0;
my $class;
open OUT, '>', 'accession-class-hapmap.txt' or die("can not open file");
open OUT2, '>', 'accession-nomatch-hapmap.txt' or die("can not open file");
foreach $key (keys %accnHapmapList) {
    if ($accnList{$key}) {
        $count++;
	#print "$key $accnList{$key}\n";
	$class = find_market_class($key, $accnList{$key});
	print OUT "$key,$class\n";
    } elsif ($accn2List{$key}) {
	$count++;
	#print "accn $key $accn2List{$key}\n";
	$class = find_market_class($key, $accn2List{$key});
        print OUT "$key,$class\n";
    } elsif ($synList{$key}) {
        $count++;
	$name = $synList{$key};
	print "syn $key name $name id $accnList{$name}\n";
	$class = find_market_class($name, $accnList{$name});
        print OUT "$key,$class\n";
    } elsif ($key =~ /([^\s]+)_C1/) {
	$count++;
	$name = $1;
	$class = find_market_class($name, $accnList{$name});
	print OUT "$key,$key,$class\n";
    } else {
        print OUT2 "$key, not found\n";
    }
}
print "$count matches from PHG\n";

$dbh->disconnect();


