#!/usr/bin/perl

# check for overlap between 90K and Exome Capture files
#

use DBI;
use strict;
use warnings;
use Text::CSV;

my $driver   = "SQLite"; 
my $database = "/data2/phg2/phgWC400v2.1.db";
my $dsn = "dbi:$driver:dbname=$database";
my $userid = "sqlite";
my $password = "sqlite";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
   or die $DBI::errstr;

print "Opened database successfully\n";

my $line;
my @lineA;
my $chrom;
my $name;
my @row;
my $loc;
my $sql;
my $rv;
my $sth;
my $sth2;
my $sth3;
my $count = 0;
my $count_nf = 0;
my %accn1;
my %accn2;
my %accn3;

my $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/TCAP90K_HWWAMP-strand.vcf";
my $file2 = "/data2/phg2/PHG470v2-31_db.vcf";
my $file3 = "/data2/phg2/tempFileDir/outputDir/TCAP90K_HWWAMP-strand.vcf";
my $fileT = "/data2/phg2/tempFileDir/PHG472_T3Matches20221004.csv";

my $allele_id;
my $allele_string;
my %accessionList;
$sql = "select line_name from genotypes";
$sth = $dbh->prepare($sql);
$sth->execute or die "Can't execute $sql";
while (@row = $sth->fetchrow_array()) {
    $count++;
    $name = uc($row[0]);
    chomp($name);
    $accessionList{$name} = 1 ;
}
print "$count from genotypes table\n";
$count = 0;

my $index;
my $key;
my $key1;
my $key2;
my $countA = 0;
my $countM = 0;
my %acc1List;
my %marker1;
my %marker2;
my %marker3;

my %translate;
my $csv = Text::CSV->new();
open(my $fh, '<', $fileT) or die $!;
while(my $row = $csv->getline($fh)) {
   @lineA = @$row;
   if ($lineA[1] =~ /NoMatch/) {
       if ($lineA[2] =~ /NotApp/) {
	   if ($lineA[3] =~ /NotApp/) {
	       #print "$lineA[0] not found\n";
	   } else {
	       $count++;
	       $translate{$lineA[0]} = $lineA[3];
	       #print "found col3 $lineA[0] $lineA[3]\n";
	   }
       } else {
	   $count++;
	   $translate{$lineA[0]} = $lineA[2];
	   #print "found col2 $lineA[0] $lineA[1]\n";
       }
   } else {
       $count++;
       $translate{$lineA[0]} = $lineA[1];
       #print "found col1 $lineA[0] $lineA[1]\n";
   }
}
close(FH);
print "found $count in $fileT\n";

open(FH, '<', $file1) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @lineA = split /\t/, $_;
	foreach $key (keys @lineA) {
            if ($key > 8) {
		$countA++;
		$name = uc($lineA[$key]);
		chomp($name);
		$accn1{$name} = 1;
	    }
	}
    } else {
	@lineA = split /\t/, $_;
	$countM++;
	$index = $lineA[0] . "_" . $lineA[1];
        $marker1{$index} = $_;
    }
}
close(FH);
print "$countA accessions from $file1\n";
print "$countM markers from $file1\n";

$countA = 0;
$countM = 0;
open(FH, '<', $file2) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @lineA = split /\t/, $_;
        foreach $key (keys @lineA) {
	    if ($key > 8) {
		$countA++;
		$name = uc($lineA[$key]);
                chomp($name);
		if (exists($translate{$name})) {
		    #print "found2 $name $translate{$name}\n";
		    $name = $translate{$name};
		}
		if ($name eq "UI_PLATINUM") {
                    $name = "PLATINUM";
                } elsif ($name eq "CHOTEAU2") {
                    $name = "CHOTEAU";
                } elsif ($name eq "C0940610") {
                    $name = "CO940610";
                } elsif ($name eq "OVERLEY") {
                    $name = "OVERLAY";
                } elsif ($name eq "KELSE") {
                    $name = "KESLEY";
                } elsif ($name eq "CNN") {
                    $name = "CHEYENNE";
                } elsif ($name eq "KS030887K-6") {
                    $name = "KANMARK";
                }
		$accn2{$name} = 1;
	    }
        }
	#last;
    } else {
        @lineA = split /\t/, $_;
	$countM++;
        $index = $lineA[0] . "_" . $lineA[1];
        $marker2{$index} = 1;
	if (($countM % 100000) == 0) {
            print "done $countM\n";
        }

    }	
}
close(FH);
print "$countA accessions from $file2\n";
print "$countM markers from $file2\n\n";

$count = 0;
$countA = 0;
$countM = 0;
open(FH, '<', $file3) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
      @lineA = split /\t/, $_;
      foreach $key (keys @lineA) {
          if ($key > 8) {
              $countA++;
              $name = uc($lineA[$key]);
	      chomp($name);
	      if (exists($translate{$name})) {
		    #print "found3 $name $translate{$name}\n";
                    $name = $translate{$name};
              }
              $accn3{$name} = 1;
          }  
      }
      #last;
    } else {
      @lineA = split /\t/, $_;
        $countM++;
        $index = $lineA[0] . "_" . $lineA[1];
        $marker3{$index} = 1;
        if (($countM % 100000) == 0) {
            print "done $countM\n";
        }
    }
}
close(FH);
print "$countA accessions from $file2\n";
print "$countM markers from $file2\n\n";

$count = 0;
foreach $name (keys %accessionList) {
    if ($accn3{$name}) {
        $count++;
    } else {
	    #print "$name not found\n";
    }
}
print "$count accessions between $file3 and PHG\n";


$count = 0;
my $count2 = 0;
foreach $name (keys %accn1) {
    if ($accn2{$name}) {
	$count++;
    }
    if ($accn3{$name}) {
	$count2++;
    }
}
print "$count between $file1 and $file2\n";
print "$count2 between $file1 and $file3\n";

$count = 0;
$count2 = 0;
my $count3 = 0;
foreach $name (keys %marker1) {
    if ($marker2{$name}) {
	$count++;
    }
    if ($marker3{$name}) {
	$count2++;
    }
}
print "\n";
print "$count overlap between $file1 and $file2\n";
print "$count2 overlap between $file1 and $file3\n";

$count = 0;
$count2 = 0;
$count3 = 0;
foreach $name (keys %marker2) {
    if ($marker3{$name}) {
        $count++;
        if ($marker1{$name}) {
           $count2++;
	}
    }
}
print "\n";
print "$count overlap between $file2 and $file3\n";
print "$count2 overlap between $file1, $file2 and $file3\n";

