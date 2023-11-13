#!/usr/bin/perl

# check for accession overlap between 90K and Exome Capture files
#

use DBI;
use strict;
use warnings;

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
my %accessionList;

my $file1 = "/data2/phg/tempFileDir/inputDir/imputation/vcf/TCAP90K_HWWAMP.vcf";
   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90K_inPHG-strand.vcf";
#my $file2 = "/data2/phg/tempFileDir/inputDir/imputation/vcf/2018_WheatCAP_0.vcf";
#my $file2 = "/var/www/html/t3/wheat/raw/genotype/2019_hapmap.vcf";
#my $file2 = "/var/www/html/t3/wheat/raw/genotype/1kEC_genotype01222019f.vcf";
#my $file2 = "/var/www/html/t3/wheat/raw/genotype/1kEC_genotype01222019.vcf.clean2";
my $file2 = "/data2/wheat/2019_hapmap.vcf";
   $file2 = "/data/wheat/phg-exome/2019_hapmap_v2.vcf";
   #$file2 = "/data2/phg2/PHG470v2-31_db.maf_seg.vcf";
my $file3 = "/data2/phg/tempFileDir/inputDir/imputation/vcf/PHG-wheat.csv";
   $file3 = "/data2/phg2/tempFileDir/outputDir/90K_inPHG-strand.vcf";

my $allele_id;
my $allele_string;
$sql = "select line_name from genotypes";
$sth = $dbh->prepare($sql);
$sth->execute or die "Can't execute $sql";
while (@row = $sth->fetchrow_array()) {
    $count++;
    $name = $row[0];
    $accessionList{$name} = 1 ;
}
print "$count from genotypes table\n";
$count = 0;

my $key;
my $key1;
my $key2;
my %acc1List;
open(FH, '<', $file1) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @lineA = split /\t/, $_;
	foreach $key (keys @lineA) {
            if ($key > 8) {
		$count++;
		$name = uc($lineA[$key]);
		chomp($name);
		if ($name eq "UC-PATWIN-515HP") {
                    print "change $name ";
                    $name = "PATWIN515-HIGH_PROTEIN";
                    print "to $name\n";
                }
		$acc1List{$name} = 1;
	    }
	}
    }
}
close(FH);
print "$count accessions from $file1\n";

$count = 0;
my %acc2List;
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
		$acc2List{$name} = 1;
	    }
        }
    }
}
close(FH);
print "$count accessions from $file2\n";

$count = 0;
my %acc3List;
open(FH, '<', $file3) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @lineA = split /\t/, $_;
        foreach $key (keys @lineA) {
            if ($key > 8) {
                $count++;
                $name = uc($lineA[$key]);
		chomp($name);
                $acc3List{$name} = 1;
            }
        }
    }
}
close(FH);
print "$count accessions from $file3\n";

$count = 0;
my $count2 = 0;
my $count3 = 0;
foreach $name (keys %acc1List) {
    if ($acc2List{$name}) {
	$count++;
	#print "found $name\t";
	if ($acc3List{$name}) {
	    $count3++;
	    #print "$name\n";
	} else {
	    #print "\n";
	}
    } else {
	    #print "$name not found\n";
    }
    if ($acc3List{$name}) {
	$count2++;
    }
}
print "\n";
print "$count overlap between $file1 and $file2\n";
print "$count2 between $file1 and $file3 \n";
print "$count3 in both\n\n";

$count = 0;
$count2 = 0;
$count3 = 0;
foreach $name (keys %acc2List) {
    if ($acc1List{$name}) {
        $count++;
        if ($acc3List{$name}) {
            $count3++;
        }
    } else {
            #print "$name not found\n";
    }
    if ($acc3List{$name}) {
        $count2++;
    }
}
print "$count overlap between $file1 and $file2\n";
print "$count2 between $file2 and $file3\n";
print "$count3 in both\n";
