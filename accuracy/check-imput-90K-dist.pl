#!/usr/bin/perl

# compares percentage of similar loci for each accession  
# requires that protocols have correct ref, alt, and strand
# compares common markers and accessions
#
# todo - handle the case where input file has duplicate accessions
#   identify and rename duplicates

use DBI;
use strict;
use warnings;
use Text::CSV;

my $driver   = "SQLite"; 
my $database = "/data2/phg/tempFileDir/outputDir/phgWCv1.db";
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

my $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/TCAP90K_HWWAMP-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/TCAP90K_SWWpanel-strand.vcf";
   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KinPHGv2-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/9KinPHGv2-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KinPHGv2-strand.vcf";
   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KnotinPHGv2-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/9KnotinPHGv2-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KinPHGv2-strand-d10.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KinPHGv2-strand-d100.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/GMS90K-WheatCAP-protocol-21022_v2.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/PHGv2notInPHG-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/NSGCwheat9K_4X-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/TCAP90K_NAMparents_panel-strand.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/USCultIDnum-22Val-USDA3KWheat-CSv21_fixed.clean.vcf";
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/SNBWW_genotypesort90k_tassel-strand.vcf";
my $file2 = "/data2/phg2/PHG470v2-31_db.vcf";
   $file2 = "/data2/wheat/2019_hapmap.vcf";
   $file2 = "/data/wheat/phg-exome/2019_hapmap_v2.vcf";
   $file2 = "/data/wheat/phg-exome/2019_hapmap_all.vcf";
   #$file2 = "/data/wheat/phg-exome/2019_hapmap_v2_3k.vcf";
   #$file2 = "/data/wheat/phg-exome/2019_hapmap_v2_10k.vcf";
my $file3 = "/data2/phg2/tempFileDir/outputDir/TCAP90K_HWWAMP-strand.vcf.save";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/TCAP90K_SWWpanel-strand.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/TCAP90K_HWWAMP_SRPN-strand.vcf";
   $file3 = "/data2/phg2/tempFileDir/outputDir/90KinPHGv2-strand.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/9KinPHGv2-strand.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/90KnotinPHGv2-strand.vcf.save";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/9KnotinPHGv2-strand.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/90KinPHGv2-strand-d10.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/90KinPHGv2-strand-d100.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/GMS90K-WheatCAP-protocol-21022_v2.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/90K_notInPHG-strand.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/NSGCwheat9K_4X-strand.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/TCAP90K_NAMparents_panel-strand.vcf.save2";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/USCultIDnum-22Val-USDA3KWheat-CSv21_fixed.cleaned.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/SNBWW_genotypesort90k_tassel-strand.vcf";
my $fileT = "/data2/phg2/tempFileDir/PHG472_T3Matches20221004.csv";
my $file4 = "results-90K-notinPHG-dist.csv";
my $file5 = "results-90K-imp-1";
my $file6 = "results-90K-imp-2";

my $allele_id;
my $allele_string;

$sql = "select ref_range_id from reference_ranges where chrom = ? and (range_start < ?) and (range_end > ?)";
$sth = $dbh->prepare($sql);
$sql = "select ref_allele_id, alt_allele_id from variants where chrom = ? and position = ?";
$sth2 = $dbh->prepare($sql);

my $index;
my $key;
my $key1;
my $key2;
my %marker1;
my %marker2;
my %marker3;
my %maf2;
my %maf3;
my $cnt1;
my $cnt2;
my $freq1;
my $freq2;
my @line2A;
my @line3A;
my @header1A;


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

open(FH, '<', $file1) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @header1A = split /\t/, $_;
	foreach $key (keys @header1A) {
            if ($key > 8) {
	        $name = uc($header1A[$key]);
		#print "found $name\n";
		$header1A[$key] = $name;
		$accessionList{$name} = 1;
            }
	}
    } else {
	$count++;
	chomp;
	@lineA = split /\t/, $_;
	$index = $lineA[0] . "_" . $lineA[1];
	$marker1{$index} = $_;
    }
}
close(FH);
print "$count markers from $file1\n";

$count = 0;
my $countMarkers = 0;
my $countAccn = 0;
my @header2A;
my %overlapImpMarker;
open(FH, '<', $file2) or die $!;
open(FH2, '>', $file4) or die $!;
while(<FH>){
	#$line =~ s/\r//g;
	#$line =~ s/\n//g;
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @header2A = split /\t/, $_;
        foreach $key (keys @header2A) {
	    if ($key > 8) {
		$name = uc($header2A[$key]);
                chomp($name);
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
                } elsif ($name eq "PATWIN515-HIGH_PROTEIN") {
		    print "found PATWIN515-HIGH_PROTEIN\n";
		    $name = "UC-PATWIN-515HP";
		}
                $header2A[$key] = $name;
                if ($accessionList{$name}) {
                    $countAccn++;
                }
            }
        }
	print "$countAccn accessions match file2\n";
    } else {
	$count++;
	chomp;
        @lineA = split /\t/, $_;
        $index = $lineA[0] . "_" . $lineA[1];
	s/\r//g;
	s/\n//g;
	$marker2{$index} = $_;
        if (($count % 100000) == 0) {
            print "done $count\n";
	    #if ($count == 100000) {
	    # 	    last;
	    #}
        }
    }
}
close(FH);
print "$count from $file2\n";

$count = 0;
my @header3A;
my $accession;
open(FH, '<', $file3) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
        @header3A = split /\t/, $_;
    } else {
	$count++;
    }
}
close(FH);
print "$count markers from $file3\n";

$count = 0;
$countAccn = 0;
my $accName;
my $accName2;
my $line1;
my $line2;
my $line3;
my @line1A;
my $perc;
my $countData;
my $avg;
my $sum;
my %cnt;
my %countMatchA;
my %countDiffA;
my %countDataA;
foreach $name (keys %marker1) {
    if ($marker2{$name}) {
	$count++;
	if (($count % 10000) == 0) {
            print "done $count\n";
	}
	my $countMatch = 0;
	my $countDiff = 0;
	$countAccn = 0;
	$line1 = $marker1{$name};
	@line1A = split /\t/, $line1;
	$line2 = $marker2{$name};
	@line2A = split /\t/, $line2;
	$countData = 0;
	foreach $key1 (keys @header1A) {
	    if ($key1 > 8) {
	        $accName = $header1A[$key1];
		foreach $key2 (keys @header2A) {
	            if ($key2 > 8) {
		    $accName2 = $header2A[$key2];
		    $index = $accName . "\t" . $accName2;
		    if ( ($line1A[$key1] =~ /\d/) && ($line2A[$key2] =~ /\d/) ) {
			$countDataA{$index} = 1;
			if ($line1A[$key1] eq $line2A[$key2]) {
			        $countMatchA{$index}++;
			} else {
			        $countDiffA{$index}++;
		        }
                    }
	    }
		}
            }
	}
    }
}
my $min = 0;
my @spl;
my $minName;
my $prev = "";
    foreach $key (sort keys %countDataA) {
        if ($countDataA{$key} > 0) {
	    if (!$countMatchA{$key}) {
		$countMatchA{$key} = 0;
	    }
	    if (!$countDiffA{$key}) {
		$countDiffA{$key} = 0;
	    }
	    $perc = $countMatchA{$key} / ($countMatchA{$key} + $countDiffA{$key});
	    @spl = split("\t", $key);
	    if ($spl[0] ne $prev) {
	        print "best $prev\t$minName\t$min\n";
		print FH2 "$prev\t$minName\t$min\n";
	        $min = 0;
		$prev = $spl[0];
	    }
	    if ($perc > $min) {
		$min = $perc;
		$minName = $spl[1];
		#print "good $spl[0] $spl[1] $perc\n";
	    } else {
		#print "bad $spl[0] $spl[1] $perc\n";
	    }
	} else {
	    print "skip $line1A[2] $name $countData\n";
	}
    }
close(FH2);
print "$count overlapping markers\n";

