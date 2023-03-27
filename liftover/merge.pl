use strict;
use warnings;

#merge vcf files
#chrom, pos, ref, and alt must be the same
#skip and arn if ref or alt is different
#rename duplicate accessions

my $file1 = "/data/wheat/liftover/2019_hapmap_all.vcf";
#   $file1 = "/data/phg/TCAP90K_NAMparents_panel-strand.vcf";
my $file2 = "/data/phg/PHG470v2-31_db.maf_seg_filter2.recode.vcf";

my $file_out = $file1 . ".merged";
my $file_out2 = "phg_merge_skipped.vcf";

my $line;
my @lineA = ();
my $chrom;
my $pos;
my $ref;
my $alt;
my $key;
my $index;
my $index2;
my %list1;
my %list1r;
my %list1a;
my %index2;
my %unique;
my $name;
my $count = 0;
my $countA;
my $count_skip = 0;
my $count_dup = 0;

open my $fh, "<$file1" or die "Could not open $file1: $!";
open my $fh3, ">$file_out" or die "Could not write to $file_out: $!";
open my $fh4, ">$file_out2" or die "Could not write to $file_out2: $!";
print "opened $file1\n";
$count = 0;
while($line = <$fh>) {
    $count++;
    if (($count % 100000) == 0) {
	print "done $count\n";
    }
    chomp($line);
    @lineA = split(/\t/, $line);
    if ($line =~ /^##/) {
	print $fh3 "$line\n";
    } elsif ($line =~ /^#chrom/i) {
	$countA = scalar @lineA;
	print "$count $countA from $file1\n";
	sleep(2);
	foreach $key (keys @lineA) {
            if ($key > 8) {
                if (exists $unique{$lineA[$key]}) {
		    $count_dup++;
	            $name = $lineA[$key] . "_C" . $unique{$lineA[$key]};
		    print $fh3 "\t$name";
                    print "$key $count_dup duplicate $lineA[$key] $name\n";
		    $unique{$lineA[$key]}++;
		} else {
		    print $fh3 "\t$lineA[$key]";
		    #print "$key good $lineA[$key]\n";
		    $unique{$lineA[$key]} = 1;
		}
            } else {
		if ($key == 0) {
		    print $fh3 "$lineA[$key]";
		} else {
	            print $fh3 "\t$lineA[$key]";
		}
	    }
        }
    } else {
	if ($lineA[0] =~ /^(\d\w)/) {
	    $chrom = $1;
        } elsif ($lineA[0] =~ /Chr(\d\w)/) {
	    $chrom = $1;
	} elsif ($lineA[0] =~ /Un/) {
	    $chrom = $lineA[0];
	} else {
	    print "Error $lineA[0]\n";
	    $chrom = $lineA[0];
	}
	$pos = $lineA[1];
	$ref = $lineA[3];
	$alt = $lineA[4];
	$index = $chrom . "_" . $pos;
	$list1{$index} = $line;
	$list1r{$index} = $ref;
        $list1a{$index} = $alt;
    }
}
close($fh);
print "$count from $file1\n";

my $append;
open $fh, "<$file2" or die "Could not open $file2: $2";
$count = 0;
@lineA = ();
while($line = <$fh>) {
    $count++;
    chomp($line);
    @lineA = split(/\t/, $line);
    if ($line =~ /^##/) {
    } elsif ($line =~ /^#chrom/i) {
	$countA = scalar @lineA;
        print "$count $countA from $file2\n";
	sleep(2);
	foreach $key (keys @lineA) {
            if ($key > 8) {
		$name = $lineA[$key];
		if (exists $unique{$name}) {
		    $name = $lineA[$key] . "_C" . $unique{$name};
		    print "$key duplicate $lineA[$key] $name\n";
		    print $fh3 "\t$name";
		    $unique{$name}++;
		} else {
		    #print "$key good $lineA[$key]\n";
	            print $fh3 "\t$lineA[$key]";
		    $unique{$name} = 1;
		}
	    }
	}
        print $fh3 "\n";
    } else {
        $chrom = $lineA[0];
        $pos = $lineA[1];
        $ref = $lineA[3];
        $alt = $lineA[4];
        $index = $chrom . "_" . $pos;
	$index2 = $ref . "-" . $alt;
	$append = "";
	foreach $key (keys @lineA) {
	    if ($key > 8) {
		$append .= "\t$lineA[$key]";
	    }
	}
	if ($list1{$index}) {
	    if ($list1r{$index} eq $ref) {
		if ($list1a{$index} eq $alt) {
		    print $fh3 "$list1{$index}$append\n";
		} else {
		    $count_skip++;
			#print "bad alt $index $list1r{$index} $list1a{$index} $index2\n";
		    print $fh4 "$list1{$index}$append\n";
		}
		if ($count < 10) { print scalar @lineA; }
	    } else {
		$count_skip++;
		    #print "bad ref $index $list1r{$index} $list1a{$index} $index2\n";
		 print $fh4 "$list1{$index}$append\n";
            }
        }	    
    }
    if (($count % 10000) == 0) {
	print "done $count\n";
    }
}
close($fh);
print "$count from $file2\n";
print "$count_skip skipped\n";
