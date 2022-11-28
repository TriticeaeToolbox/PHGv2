#!/usr/bin/perl

# given the same accession from 90K and from Exome Capture
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
#   $file1 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/TCAP90K_HWWAMP_SRPN-strand.vcf";
my $file2 = "/data2/phg2/PHG470v2-31_db.vcf";
#   $file2 = "/data2/wheat/2019_hapmap.vcf";
my $file3 = "/data2/phg2/tempFileDir/outputDir/TCAP90K_HWWAMP-strand.vcf";
#   $file3 = "/data2/phg2/tempFileDir/outputDir/TCAP90K_HWWAMP_SRPN-strand.vcf";
my $fileT = "/data2/phg2/tempFileDir/PHG472_T3Matches20221004.csv";
my $file4 = "results-90K-raw.csv";
my $file5 = "results-90K-imp-byaccn.csv";
my $file6 = "results-90K-imp-bymark.csv";

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
        @lineA = split /\t/, $_;
        $index = $lineA[0] . "_" . $lineA[1];
	s/\r//g;
	s/\n//g;
	$marker2{$index} = $_;
        if (($count % 100000) == 0) {
            print "done $count\n";
	    if ($count == 1000000) {
		    last;
            }
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
        foreach $key (keys @header3A) {
            if ($key > 8) {
                $name = $header3A[$key];
            }
        }
    } else {
        $count++;
        @lineA = split /\t/, $_;
        $index = $lineA[0] . "_" . $lineA[1];
        $marker3{$index} = $_;
	if (($count % 100000) == 0) {
            print "done $count\n";
            if ($count == 1000000) {
		    #last;
	    }
        }
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
		    $accName2 = $header2A[$key2];
		    if ($accName eq $header2A[$key2]) {
			$countAccn++;
			#print "found $key1 $key2 $name $accName $line1A[$key1] $line2A[$key2]\n";
			if ( ($line1A[$key1] =~ /\d/) && ($line2A[$key2] =~ /\d/) ) {
			    $countDataA{$accName} = 1;
			    if ($line1A[$key1] eq $line2A[$key2]) {
			        $countMatchA{$accName}++;
			    } else {
			        $countDiffA{$accName}++;
			    }
			} 
		    } elsif (($accName =~ /_C\d$/) && ($accName =~ /$accName2/)) {
                        #print "found $accName $accName2\n";
                        if ( ($line1A[$key1] =~ /\d/) && ($line2A[$key2] =~ /\d/) ) {
                           $countDataA{$accName} = 1;
                            if ($line1A[$key1] eq $line2A[$key2]) {
                                $countMatchA{$accName}++;
                            } else {
                                $countDiffA{$accName}++;
                            }
                        }
                    }
		}
            }
	}
    }
}
    foreach $key (keys %countDataA) {
        if ($countDataA{$key} > 0) {
	    $perc = $countMatchA{$key} / ($countMatchA{$key} + $countDiffA{$key});
	    $sum += $perc;
	    $countAccn++;
	    print FH2 "$key,$countDataA{$key},$countMatchA{$key},$countDiffA{$key},$perc\n";
	} else {
	    print "skip $line1A[2] $name $countData\n";
	}
    }
close(FH2);
print "$count overlapping markers\n";
$perc = $sum / $countAccn;
print "average = $perc\n";

$count = 0;
$sum = 0;
%cnt = ();
%countMatchA = ();
%countDiffA = ();
%countDataA = ();
open(FH2, '>', $file5) or die $!;
foreach $name (keys %marker3) {
    if ($marker2{$name}) {
        my $countMatch = 0;
        my $countDiff = 0;
        $countAccn = 0;
	if ($marker1{$name}) {
	  $count++;
          $line2 = $marker2{$name};
          @line2A = split /\t/, $line2;
	  $line3 = $marker3{$name};
          @line3A = split /\t/, $line3;
          foreach $key1 (keys @header3A) {
            if ($key1 > 8) {
                $accName = uc($header3A[$key1]);
		$countAccn = 1;
                foreach $key2 (keys @header2A) {
		    $accName2 = $header2A[$key2];
		    if ($accName eq $header2A[$key2]) {
                        $countAccn++;
			#print "found $key1 $key2 $name $accName $line3A[$key1] $line2A[$key2]\n";
                        if ( ($line3A[$key1] =~ /\d/) && ($line2A[$key2] =~ /\d/) ) {
			    $countDataA{$accName}++;
                            if ($line3A[$key1] eq $line2A[$key2]) {
                                $countMatchA{$accName}++;
                            } else {
                                $countDiffA{$accName}++;
                            }
			}
                    } elsif (($accName =~ /_C\d$/) && ($accName =~ /$accName2/)) {
			#print "found $accName $accName2\n";
			if ( ($line3A[$key1] =~ /\d/) && ($line2A[$key2] =~ /\d/) ) {
			   $countDataA{$accName}++;
                            if ($line3A[$key1] eq $line2A[$key2]) {
                                $countMatchA{$accName}++;
                            } else {
                                $countDiffA{$accName}++;
                            }
		        }
		    }
                }
	     }
	     }
        if (($count % 1000) == 0) {
            print "$count compared\n";
        }
}
    }
    if ($count > 100000) {
	    last;
    }
}
my $phg;
$sum = 0;
$countAccn = 0;
	  #if (($countMatch > 0) || ($countDiff > 0)) {
	  foreach $key (keys %countDataA) {
	      if ($countDataA{$key} > 0) {
		#print "key = $key countDataA $countDataA{$key} countMatch $countMatchA{$key} countDiff $countDiffA{$key}\n";
                $perc = $countMatchA{$key} / ($countMatchA{$key} + $countDiffA{$key});
		$sum += $perc;
		$countAccn++;
		if (defined($translate{$key})) {
		    $phg = "yes";
		} else {
		    $phg = "no";
		}
		print FH2 "$key,$phg,$countDataA{$key},$countMatchA{$key},$countDiffA{$key},$perc\n";
		print "$key,$phg,$countDataA{$key},$countMatchA{$key},$countDiffA{$key},$perc\n";
              } else {
		    # print "$name count 0\n";
              }
	  }
print "$count overlapping markers\n";
$perc = $sum / $countAccn;
print "average = $perc\n";
die();

my @lineAImp;
my @lineARaw;
my $gt1;
my $gt2;
my $gt3;
$count = 0;
my $countGT = 0;
my $countMis = 0;
open(FH, '<', $file3) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
	@header3A = split /\t/, $_;
	print "header $file3\n$_\n";
    } else {
        $count++;
        @lineA = split /\t/, $_;
        $index = $lineA[0] . "_" . $lineA[1];
        $name = $lineA[2];
	if ($overlapImpMarker{$index}) {
	    $line = $overlapImpMarker{$index};
	    print "imputed $line";
	    @lineAImp = split /\t/, $line;
	    #$line = $overlapRawMarker{$index};
	    print "raw $line";
	    @lineARaw = split /\t/, $line;
	    $name = $lineARaw[2];
	    $countGT = 0;
	    $countMis = 0;
 	    foreach $key (keys @lineA) {
		if ($key > 8) {
		    $gt1 = "";
		    $gt2 = "";
		    $gt3 = $lineA[$key];
		    $accession = $header3A[$key];
		    if ($accession eq "UC-Patwin-515HP") {
			$accession = "PATWIN515-HIGH_PROTEIN";
		    }
		    print "accession = $accession\n";
		    foreach $key1 (keys @header1A) {
		        if ($accession eq $header1A[$key1]) {
			    print "found1$key1\n";
			    $gt1 = $lineARaw[$key1];
		        }
		    }
		    if ($gt1 eq "") { print "$accession not found in header1\n"; }
		    foreach $key2 (keys @header2A) {
			if ($accession eq $header2A[$key2]) {
                            print "found2 $key2\n";
                            $gt2 = $lineARaw[$key2];
                        }
		    }
		    if ($gt2 eq "") { print "$accession not found in header2\n"; }
		    print "$gt1 $gt2 $gt3\n";
	        }
	    }
	    print "$index $count $countMis $countGT  match\n";
	    die();
	}
    }
}
