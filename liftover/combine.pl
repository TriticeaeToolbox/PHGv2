use strict;
use warnings;
use PerlIO::gzip;

#concatanate gzip VCF files

my $file_out = "2019_hapmap_all.vcf";
my $line;
my $fh;
my $count = 0;

open my $fh2, ">$file_out" or die "Could not write to $file_out: $!";

opendir my $dir, "/data/wheat/liftover" or die "Cannot open directory: $!";
my @files = sort readdir $dir;
closedir $dir;

foreach (@files) {
    if (/2019_hapmap_[\dU]/) {
	print "found $_\n";
        open my $fh, '<:gzip', $_  or die("Error opening $_\n");
	if ($count == 0) {
	    while($line = <$fh>) {
		$line =~ s/^Chr//;
		print $fh2 $line;
	    }
	} else {
            while($line = <$fh>) {
	        if ($line =~ /^#/) {
	        } else {
		    $line =~ s/^Chr//;
	            print $fh2 $line;
                }
	    }
	}
	close($fh);
	$count++;
    }
}
close($fh2);
print "$count files found\n";


