<?php

#compare ref allele in 90K to assembly, if different then convert ref and genotypes to match assembly
#
#check for accessions with no data and remove that accession
#if duplicate accessions then add suffix _C2, _C3, ...
#skip "Un" chromosomes because they are not in PHG
#$file is input file
#$file2 is output file

$file = "TCAP90K_HWWAMP.vcf";
$file2 = "TCAP90K_HWWAMP-strand.vcf";

if (($reader = fopen($file, "r")) == FALSE) {
    die("can not open $file\n");
}
if (($writer = fopen($file2, "w")) == FALSE) {
    die("can not open $file\n");
}

function compliment($base) {
    if ($base == "A") {
	return "T";
    } elseif ($base == "T") {
	return "A";
    } elseif ($base == "G") {
	return "C";
    } elseif ($base == "C") {
	return "G";
    } else {
	print "Error base compliment: $base";
	$base = strtr($base, "ACTG", "TGAC");
	print " $base\n";
    }
}

$count = 0;
$count_nf = 0;
$count_change = 0;
$missing = [];
while (!feof($reader)) {
    $count++;
    $line = fgets($reader);
    $line = str_replace("\r", "", $line);
    $line = str_replace("\n", "", $line);
    if (preg_match('/^##/', $line)) {
    } elseif (preg_match('/^#/', $line)) {
	$lineA = explode("\t", $line);
	foreach ($lineA as $key=>$gt) {
	    $missing[$key] = 0;
	}
    } else {
        $lineA = explode("\t", $line);
        foreach ($lineA as $key=>$gt) {
          if ($key > 8) {
            if (substr($gt,0,3) == "0/0") {
                $missing[$key]++;
            } elseif (substr($gt,0,3) == "1/1") {
		$missing[$key]++;
	    } elseif (substr($gt,0,3) == "0/1") {
	    } elseif (substr($gt,0,3) == "./.") {
	    } elseif (substr($gt,0,3) == "1/0") {
	    } elseif (substr($gt,0,3) == "2/2") {
	    } else {
	        print "Error GT $key $gt\n";
	    }
	  }
	}
    }
}
foreach ($missing as $key=>$gt) {
    if ($missing[$key] < 1) {
	print "Error $key $gt missing data\n";
    }
}
fclose($reader);
sleep(2);
if (($reader = fopen($file, "r")) == FALSE) {
    die("can not open $file\n");
}

$count = 0;
$count_nf = 0;
while (!feof($reader)) {
    $count++;
    $line = fgets($reader);
    $line = preg_replace("/\r/", "", $line);
    $line = preg_replace("/\n/", "", $line);
    $lineA = explode("\t", $line);
    if (preg_match('/^#CHROM/', $line)) {
	foreach ($lineA as $key=>$name) {
	    if ($key > 8) {
		if ($missing[$key] < 1) {
	            unset($lineA[$key]);
		    print "removing $key $name because no data\n";
		    sleep(2);
		}
		if (isset($unique[$name])) {
		    $NewName = $name . "_C" . $unique[$name];
		    $lineA[$key] = $NewName;
		    $unique[$name]++;
		    print "duplicate accession $name to $NewName $unique[$name]\n";
		} else {
		    $unique[$name] = 1;
		    print "good $name\n";
		}
            }
	}
	$line = implode("\t", $lineA);
	fwrite($writer, "$line\n");
	continue;
    } elseif (preg_match('/^#/', $line)) {
	fwrite($writer,"$line\n");
	continue;
    }
    $chrom = $lineA[0];
    $pos = $lineA[1];
    $name = $lineA[2];
    $ref = $lineA[3];
    $alt = $lineA[4];
    if ($chrom == "wn") {
	$chrom = "Unk";
    } elseif ($chrom == "Un") {
	$chrom = "Unk";
    }
    if (preg_match("/\w/", $alt)) {
    } else {
	print "skip line no alt $line\n";
	continue;
    }
    if (preg_match("/\d/",$pos)) {
	if (preg_match("/Un/", $chrom)) {
	#if ($chrom == "Un") {
	    #print "bad chromosome $chrom\n"; 
	    continue;
	}
	if ($pos == 0) {
	    print "skip $name $pos\n";
	    continue;
	}
	$chrom = preg_replace('/chr/', '', $chrom);
	$chrom = preg_replace('/Chr/', '', $chrom);
	if (preg_match("/Chr/", $chrom)) {
	    $range = $chrom . ":" . $pos . "-" . $pos;
	} else {
	    $range = "Chr" . $chrom . ":" . $pos . "-" . $pos;
	    #$start = $pos - 1;
	    #$stop = $pos + 1;
	    #$range = "Chr" . $chrom . ":" . $start . "-" . $stop;
	}
	$cmd = "samtools faidx /data/wheat/iwgsc2.1/iwgsc_refseqv2_Chr" . $chrom . ".fa $range";
	$allele = system($cmd);
	#print "$name $ref $alt $allele\n";
        $compRef = compliment($ref);
        $compAlt = compliment($alt);
        $revcompRef = compliment($alt);
	$revcompAlt = compliment($ref);
	#remove accession with no data
	foreach ($lineA as $key=>$gt) {
	    if ($key > 8) {
		if ($missing[$key] < 1) {
                    unset($lineA[$key]);
                    print "removing $key $gt because no data\n";
                }
	    }
	}
	if (!preg_match("/\w/", $allele)) {
	    $count_nf++;
            print "no allele $count $name $allele $ref $alt\n";
            fwrite($writer,"$line\n"); 
	} elseif ($allele == $ref) {
	    foreach ( $lineA as $key=>$gt) {
		if ($key > 8) {
		    if (empty($gt)) {
			    $lineA[$key] = "./.";
			    #print "$name $key found\n";
		    }
		}
	    }
	    $line = implode("\t", $lineA);
	    fwrite($writer,"$line\n");
	} elseif (preg_match("/$allele/", $alt)) {
	    $count_change++;
	    $tmp = $ref;
	    $lineA[3] = $allele;
	    $lineA[4] = $tmp;
	    foreach ( $lineA as $key=>$gt) {
		if ($key > 8) {
		if (substr($gt,0,3) == "1/1") {
		    $lineA[$key] = "0/0";
		} elseif (substr($gt,0,3) == "0/0") {
		    $lineA[$key] = "1/1";
		} elseif (substr($gt,0,3) == "0/1") {
	 	    $lineA[$key] = "0/1";
		} elseif ($gt == "./.") {
		} elseif (empty($gt)) {
		    $lineA[$key] = "./.";
		} elseif ($gt == "2/2") {
		    $lineA[$key] = "0/0";      //is this correct
		} else {
		    print "error gt $gt\n";
		}
	 	}
	    }
	    $line = implode("\t", $lineA);
	    fwrite($writer,"$line\n");
	} elseif ($allele == $compRef) {
	    $count_change++;
	    $lineA[3] = $compRef;
	    $lineA[4] = $compAlt;
	    foreach ( $lineA as $key=>$gt) {
                if ($key > 8) {
                    if (empty($gt)) {
                        $lineA[$key] = "./.";
                    }
                }
            }
	    $line = implode("\t", $lineA);
	    fwrite($writer,"$line\n");
	} elseif ($allele == $revcompRef) {
	    $count_change++;
	    $lineA[3] = $revcompRef;
	    $lineA[4] = $revcompAlt;
	    foreach ( $lineA as $key=>$gt) {
	        if ($key > 8) {
                if ($gt == "1/1") {
                    $lineA[$key] = "0/0";
                } elseif ($gt == "1/1") {
                    $lineA[$key] = "0/0";
                } elseif ($gt == "0/1") {
                    $lineA[$key] = "0/1";
                } elseif ($gt == "./.") {
                } elseif (empty($gt)) {
                    $lineA[$key] = "./.";
                }
                }
            }
	    $line = implode("\t", $lineA);
	    fwrite($writer,"$line\n");
        } else {
	    $count_nf++;
	    print "can not match allele to ref $count $name $allele $ref $alt\n";
	    $line = implode("\t", $lineA);
	    fwrite($writer,"$line\n");
	}
    } else {
	print "no position $line";
    }
}
print "$count_nf allele not found\n";
print "$count_change changed allele\n";
