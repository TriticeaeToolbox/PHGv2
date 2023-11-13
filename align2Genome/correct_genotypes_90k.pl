use strict;
use warnings;

# change (compliment) 90K sequence to match exome capture

my $line;
my @lineA;
my @lineB;
my %marker;
my $count = 0;
my $countAcc;
my $index;
my @header1A;
my @header2A;
my $key1;
my $key2;

my $file = "/data/wheat/phg-exome/2019_hapmap_all.vcf";
open(FH, '<', $file) or die $!;
while(<FH>){
    if (/^##/) {
    } elsif (/^#CHROM/) {
	@header1A = split /\t/, $_;
    } else {
	$count++;
	chomp;
	@lineA = split /\t/, $_;
        $index = $lineA[0] . "_" . $lineA[1];
        $marker{$index} = $_;
	if (($count % 100000) == 0) {
	    print "$count\n";
	}
    }
}
close(FH);
print "$count from $file\n";

my $key;
my $gt1;
my $gt2;
my $cntR;
my $cntA;
my $gtComp;
my $countGood;
my $countGood2;
my $countBad;
my $lineComp;
my @lineCompA;
my $countChange = 0;
$count = 0;
$file = "/home/cbirkett/90Kin2019hapmap-strand.vcf";
my $file2 = "/home/cbirkett/90Kin2019hapmap-strand2.vcf";
$file = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KinPHGv2-strand.vcf";
$file2 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KinPHGv2-strand2.vcf";
$file = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KnotinPHGv2-strand.vcf";
$file2 = "/data2/phg2/tempFileDir/inputDir/imputation/vcf/90KnotinPHGv2-strand2.vcf";
open(FH, '<', $file) or die $!;
open(FH2, '>', $file2) or die $!;
while(<FH>){
    if (/^##/) {
	print FH2 $_;
    } elsif (/^#CHROM/) {
	@header2A = split /\t/, $_;
	print FH2 $_;
    } else {
        $count++;
        chomp;
        @lineA = split /\t/, $_;
        $index = $lineA[0] . "_" . $lineA[1];
	if ($marker{$index}) {
	    $line = $marker{$index};
	    @lineB = split /\t/, $line;
	    $countAcc = 0;
	    $countGood = 0;
	    $countGood2 = 0;
	    $countBad = 0;
            foreach $key1 (keys @lineA) {
                if ($key1 > 8) {
                    $gt1 = $lineA[$key1];
		    foreach $key2 (keys @lineB) {
			if ($key2 > 8) {
			    $gt2 = $lineB[$key2];
			    if ($header1A[$key2] eq $header2A[$key1]) {
			        $countAcc++;
                                if ( ($lineA[$key1] =~ /[0-9]/) && ($lineB[$key2] =~ /[0-9]/) ) {
				    if ($lineA[$key1] eq $lineB[$key2]) {
				        $countGood++;
				    } else {
				        $countBad++;
				    }
				    if ($gt2 eq "0/0") {
				        $gtComp = "1/1";
				    } elsif ($gt2 eq "1/1") {
				        $gtComp = "0/0";
				    } elsif ($gt2 eq "0/1") {
				        $gtComp = "1/0";
				    } elsif ($gt2 eq "0/2") {
					$gtComp = "1/0";
				    } elsif ($gt2 eq "1/2") {
					$gtComp = "0/2";
				    } elsif ($gt2 eq "2/2") {
					$gtComp = "0/2"; 
				    } else {
				        print "error $gt2\n";
				    }
				    if ($lineA[$key1] eq $gtComp) {
				        $countGood2++;
				    }
			        }
                            }
		        }
                    }
                }
            }
	    if ($countGood < $countGood2) {
		$countChange++;
		foreach $key1 (keys @lineA) {
	            $gt1 = $lineA[$key1];
		    if ($gt1 eq "0/0") {
			$lineCompA[$key1] = "1/1"
		    } elsif ($gt1 eq "1/1") {
			$lineCompA[$key1] = "0/0";
		    } elsif ($gt1 eq "0/1") {
			$lineCompA[$key1] = "1/0";
		    } elsif ($gt1 eq "./.") {
			$lineCompA[$key1] = "./.";
		    } elsif ($gt1 eq "0/2") {
			$lineCompA[$key1] = "1/0";
		    } else {
			$lineCompA[$key1] = $gt1;
	            }
		}
		$lineComp = join("\t", @lineCompA);
		print "$count $index $countGood $countBad $countGood2\n";
		print FH2 "$lineComp\n";
	    } else {
                print FH2 "$_\n";
	    }
	} else {
	    print FH2 "$_\n";
	}
    }
}
close(FH);
print "$count from $file\n";
print "$countChange changed\n";
