use strict;
use warnings;

use Getopt::Std;
use CXGN::DB::InsertDBH;

our ($opt_H, $opt_D, $opt_p);
getopts('p:H:D:j:');

my $dbhost = $opt_H;
my $dbname = $opt_D;
my $dbpass = $opt_p;
my $dbuser = "postgres";

print "getting connection\n";
my $dbh = CXGN::DB::Connection->new( { dbhost=>$dbhost,
    dbname=>$dbname,
    dbpass=>$dbpass,
    dbuser=>$dbuser,
    dbargs=> {AutoCommit => 1,
    RaiseError => 1}
});

print STDERR "Connected to database $dbname on host $dbhost.\n";
my ($q, $sth, $tmp);

my $file = "/home/production/public/21022_v2.vcf";
# $file = "/home/production/public/22005_v2.vcf";
my $file2 = "/home/production/public/wheat90k_map_v2.txt";
my $file3 = "/home/production/public/42K-snp-positions.csv";
my $file4 = "/home/production/public/GMS90K-WheatCAP-protocol-21022_v2.vcf";
#  $file4 = "/home/production/public/GMS90K-WheatCAP-protocol-2205_v2.vcf";
my $file5 = "missing-markers.txt";

my $line;
my @lineA;
my $name;
my $name2;
my $seq;
my @row;
my $index;

my $protocol_id = 224;
my %chromList;
my %posList;
my %refList;
my %altList;
my %asmList;
my %syn;
my %sort;
my %map;

my $id;
my $count = 0;
my $count_nf = 0;

open (IN, '<', $file2);
while ($line = <IN>) {
    $count++;
    @lineA = split(/\s/, $line);
    $name = $lineA[0];
    if ($lineA[1]) {
      if ($lineA[1] =~ /Un/) {
	  $chromList{$name} = "Un";
      } elsif ($lineA[1] =~ /Chr(\w+)/) {
	  $chromList{$name} = $1;
      } else {
          $chromList{$name} = $lineA[1];
      }
    }
    if ($lineA[2] =~ /\d/) {
      $posList{$name} = $lineA[2];
    } else {
      $posList{$name} = 0;
    }
    if ($lineA[5]) {
      $refList{$name} = $lineA[3];
      $altList{$name} = $lineA[4];
      $asmList{$name} = $lineA[5];
    }
}
print "$count from $file2\n";
close IN;

#get positions from marker cache when available
print "get chromosome and position from marker cache\n";
my %variantList;
$q = "SELECT species_name, marker_name, chrom, pos, variant_name, ref, alt from materialized_markerview where reference_genome_name = 'RefSeq v2.1'";
$sth = $dbh->prepare($q);
$sth->execute();
while (@row = $sth->fetchrow_array) {
    $count++;
    $name = $row[1];
    if ($chromList{$name}) {
    } else {
        $chromList{$name} = $row[2];
        $posList{$name} = $row[3];
	$refList{$name} = $row[5];
        $altList{$name} = $row[6]
    }
    if ($refList{$name}) {
    } else {
        $refList{$name} = $row[5];
        $altList{$name} = $row[6];
    }
}
print "$count from materialized_markerview\n";

print "reading in $file3 to get synonym and missing position\n";
open (IN, '<', $file3);
while ($line = <IN>) {
    $count++;
    @lineA = split(/,/, $line);
    $name = $lineA[0];
    $id = $lineA[1];
    $syn{$id} = $name;
    if ($chromList{$name}) {
        #print "$name $chromList{$name} $lineA[2]\n";
    } elsif ($lineA[2] =~ /(\d\w)/) {
        $chromList{$name} = $1;
    }
}
print "$count from $file3\n";
close IN;

open (OUT, '>', $file4);
open (OUT2, '>', $file5);

#sort by chrom and position, allow for duplicate location
my $chrom;
my $countGood = 0;
my $countBad = 0;
my $ref;
my $ref2;
my $alt;
my $altNum;
my $c1;
my $c2;
my $c3;
my $key;
my $geno;
my $genoStr;
$count = 0;
$count_nf = 0;
open (IN, '<', $file);
while($line = <IN>) {
    $line =~ s/\r//g;
    $line =~ s/\n//g;
    if ($line =~ /^##/) {
        print OUT "$line\n";
    } elsif ($line =~ /^#/) {
	my @header = split(/\t/, $line);
	foreach $key (keys @header) {
	  if ($key > 8) {
            $name = $header[$key];
	    chomp($name);
	    if ($name =~ /(.+)_\d+$/) {
		$name = $1;
		print "$key change $header[$key] $name\n";
	        $header[$key] = $name;
	    } else {
		print "$key okay $header[$key]\n";
	    }
	    if ($name =~ /UC_/) {
		$name =~ s/UC_/UC-/;
		print "change name $name\n";
		$header[$key] = $name;
	    }
	  }
	}
	$line = join("\t", @header);
	print OUT "$line\n";
    } else {
        @lineA = split(/\t/, $line);
        $name = $lineA[2];
	if ($name =~ /_(IWB\d+)/) {
            $name2 = $1;
	} elsif ($syn{$name}) {
	    $name2 = $syn{$name};
        } else {
	    $name2 = undef;
	}

        if ($refList{$name}) {
	    $count++;
	    $ref = $refList{$name};
            $alt = $altList{$name};
	    if ($refList{$name} ne $ref) {
		print "Warning ref $refList{$name} $ref\n";
		#$alt = $refList{$name};
	    }
	    if ($altList{$name} ne $alt) {
		print "Warning alt $altList{$name} $alt\n";
		#$alt = $altList{$name};
	    }
	} elsif ($name2 && $refList{$name2}) {
	    $count++;
            $ref = $refList{$name};
            $alt = $altList{$name};
	} elsif ($name2 && $syn{$name2}) {
	    $tmp = $syn{$name2};
	    $ref = $refList{$tmp};
	    $alt = $altList{$tmp};
	    $name = $name2;
        } else {
	    $count_nf++;
	    print OUT2 "$name $name2 no SNP\n";
        }
        if ($chromList{$name}) {
	    $chrom = $chromList{$name};
	    $lineA[0] = $chrom;
	    if ($posList{$name} =~ /\d/) {
	        $lineA[1] = $posList{$name};
	    } else {
		$lineA[1] = 0;
	    }
	    if ($chrom =~ /chr([A-Za-z0-9]+)/) {
		$chrom = $1;
	    }
	    if ($chrom =~ /Un/) {
                $index = (8 * 30000000000) + $posList{$name};
            } elsif ($chrom =~ /(\d)(\w)/) {
	        $chrom = $1 . $2;
	        $c1 = $1;
	        $c2 = $2;
	        if ($c2 eq "A") {
	            $c3 = 0;
	        } elsif ($c2 eq "B") {
	            $c3 = 10000000000;
	        } elsif ($c2 eq "D") {
	            $c3 = 20000000000;
	        } else {
	            print "Error: $c2\n";
	            die();
                }
	        $index = ($c1 * 1000000000) + $c3 + $posList{$name};
	    } elsif ($chrom eq "Un") {
	        $chrom = "Un";
                $index = (8 * 1000000000) + $posList{$name};
	    } elsif ($chrom eq "Unk") {
	        $chrom = "Un";
	        $index = (8 * 1000000000) + $posList{$name};
	    } else {
	        print "Error: $chrom\n";
	       die();
	    }
	    #$index = $chromList{$name} . ":" . $posList{$name};
	    #print "$name $chrom $posList{$name} $index\n";
	    
	    if ($sort{$name}) {
		print OUT2 "$name skip duplicate 1\n";
		$name2 = $name . "_" . $lineA[3] . $lineA[4];
                $sort{$name2} = $index;
		$lineA[2] = $name2;
                $line = join("\t", @lineA);
                $map{$name2} = $line;
	    } else {
	        $sort{$name} = $index;
	        $line = join("\t", @lineA);
	        $map{$name} = $line;
	        $countGood++;
            }
	} elsif ($chromList{$name2}) {
            print "change name $name $name2\n";
            $chrom = $chromList{$name2};
            $lineA[0] = $chrom;
	    if ($posList{$name2} =~ /\d/) {
                $lineA[1] = $posList{$name2};
	    } else {
		$lineA[1] = 0;
	    }
            if ($chrom =~ /chr([A-Za-z0-9]+)/) {
                $chrom = $1;
            }
            if ($chrom =~ /Un/) {
                $index = (8 * 30000000000) + $posList{$name};
            } elsif ($chrom =~ /(\d)(\w)/) {
                $chrom = $1 . $2;
                $c1 = $1;
                $c2 = $2;
                if ($c2 eq "A") {
                    $c3 = 0;
                } elsif ($c2 eq "B") {
                    $c3 = 10000000000;
                } elsif ($c2 eq "D") {
                    $c3 = 20000000000;
                } else {
                    print "Error: $c2 $name $name2\n";
                    die();
                }
                $index = ($c1 * 1000000000) + $c3 + $posList{$name2};
            } elsif ($chrom eq "Un") {
                $chrom = "Un";
                $index = (8 * 1000000000) + $posList{$name2};
            } elsif ($chrom eq "Unk") {
                $chrom = "Un";
                $index = (8 * 1000000000) + $posList{$name2};
            } else {
                print "Error: $chrom $name $name2\n";
               die();
            }
            if ($sort{$name2}) {
                print OUT2 "$name skip duplicate 2\n";
            } else {
            $sort{$name2} = $index;
            $line = join("\t", @lineA);
            $map{$name2} = $line;
	    $countGood++;
    	    }
        } else {
	    if ($sort{$name}) {
		print OUT2 "$name skip duplicate 3\n";
	    } else {
	    $index = (8 * 30000000000);
	    $sort{$name} = $index;
	    $lineA[0] = "Un";
	    $line = join("\t", @lineA);
	    $map{$name} = $line;
	    print OUT2 "$name no Chromosome\n";
	    $countBad++;
    }
        }
    }
}
print "$count found\n";
print "$countGood good\n";
print "$countBad bad\n";
print "$count_nf SNP not found\n";

foreach $name (sort { $sort{$a} <=> $sort{$b} } keys %sort) {
    print OUT "$map{$name}\n";
}
close(OUT);

