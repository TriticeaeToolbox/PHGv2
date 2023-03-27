use strict;
use warnings;

my $chrom = "";
my $file_out = "";

#my $file = "iwgsc_refseqv2.1_assembly.fa";
my $file = "Triticum_aestivum.IWGSC.dna.toplevel.fa";

open(IN, '<', $file) or die("Error $file\n");
while(<IN>) {
    if (/^>([A-Za-z0-9]+)/) {
	if ($chrom ne "") {
	    close OUT;
	}
	$chrom = $1;
	$file_out = "iwgsc_refseqv2.1_assembly_" . $chrom . ".fa";
	$file_out = "Triticum_aestivum.IWGSC.dna.toplevel_" . $chrom . ".fa";
	open(OUT, '>', $file_out) or die("Error can not open $file_out");
	print "open $file_out\n";
	print OUT $_;
     } else {
	print OUT $_;
     }
}


