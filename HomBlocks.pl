#!/usr/bin/perl
#
#AUTHOR
#Guiqi Bi :fenghen360@126.com
#VERSION
#HomBlock v1.0
#COPYRIGHT & LICENCE
#This script is free software; you can redistribute it and/or modify it.
#This  script is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability or fitness for a particular purpose.

my $USAGE = 	"\nusage: ./HomBlocks.pl <parameters>
	 	\nparameters:
		-in=<file>                            Genome alignment outputfile derived from Muave. If you set --align, ignore this input parameter.
		-out_seq=<file>                       Output file of trimmed and concatenated sequences.
		-number=<int>                         Number of taxa used in aliggment (should be precious). If you set --align, ignore this input parameter.
		-min=<int>                            Minimum alignment length of a extracted module. (Default: unset)
		-method=[Gblocks|trimAl|BMGE|noisy]   To choose which program to be used in alignment trimming. (Default: Gblocks).
		
		--PartitionFinder                     To calculate the best subsitition model for each extracted colinear block and set best partition scheme by PartitionFinder.
		--align                               If you want to align sequences by mauve, add this parameter (Default: progressiveMauve).
		                                      Then you should split every sequence into a single file. File suffix with fasta,gb,fas,fa is acceptable.
		--path=                               Absolute path to directory where you put in fasta sequences (Under --align parameter).
		--mauve-out=                          The output file produced by mauve (Absolute path). If you set --align parameter.
		
		-help/h                               Print the usage.\n";
		

#-------------------------------------------------------------------------------------------
my $method="Gblocks";
foreach my $paras (@ARGV){
	if ($paras=~/-in/){
		$in=(split "=", $paras)[1];
	}
	if ($paras=~/out_seq/){
		$out_seq=(split "=", $paras)[1];
	}
	if ($paras=~/number/){
		$number=(split "=", $paras)[1];
	}
	if ($paras=~/-min/){
		$min=(split "=", $paras)[1];
	}
	if ($paras=~/-help/){
		print $USAGE;
	}
	if ($paras=~/-h/){
		print $USAGE;
	}
	if ($paras=~/--align/){
	    $align=1;
	}
	if ($paras=~/--PartitionFinder/){
	    $PartitionFinder=1;
	}
	if ($paras=~/method/){
	    $method=(split "=", $paras)[1];
	}
	if ($paras=~/path/){
		$path=(split "=", $paras)[1];
	}
	if ($paras=~/mauve-out/){
		$mauveout=(split "=", $paras)[1];
	}
	if ($paras=~/--trimAl-usage/){
		$trimAl_usage=1;
	}
	if ($paras=~/ -gb/){
		$gbinput=(split "=", $paras)[1];
	}
}
if($trimAl_usage){&trimAl_usage();exit;};
sub trimAl_usage{
print <<'EOF'

------------------------------------------------------------------------------------------------------------------
	trimAl v1.2 Basic usage:
	
	trimal -in <inputfile> -out <outputfile> -(other options).

	Common options (for a complete list please see the User Guide or visit http://trimal.cgenomics.org):

    -in <inputfile>          Input file in several formats (clustal, fasta, NBRF/PIR, nexus, phylip3.2, phylip).
    -compareset <inputfile>  Input list of paths for the files containing the alignments to compare.
    -matrix <inpufile>       Input file for user-defined similarity matrix (default is Blosum62).

    -out <outputfile>        Output alignment in the same input format (default stdout). (default input format)
    -htmlout <outputfile>    Get a summary of trimal's work in an HTML file.

    -clustal                 Output file in CLUSTAL format
    -fasta                   Output file in FASTA format (only use fasta format in HomBlocks)
    -nbrf                    Output file in NBRF/PIR format
    -nexus                   Output file in NEXUS format
    -mega                    Output file in MEGA format
    -phylip3.2               Output file in PHYLIP3.2 format
    -phylip                  Output file in PHYLIP/PHYLIP4 format

    -complementary           Get the complementary alignment.
    -colnumbering            Get the relationship between the columns in the old and new alignment.
    -select { n,l,m-k }      Selection of columns to be removed from the alignment. (see User Guide).
    -gt -gapthreshold <n>    1 - (fraction of sequences with a gap allowed).
    -st -simthreshold <n>    Minimum average similarity allowed.
    -ct -conthreshold <n>    Minimum consistency value allowed.
    -cons <n>                Minimum percentage of the positions in the original alignment to conserve.

    -nogaps                  Remove all positions with gaps in the alignment.
    -noallgaps               Remove columns composed only by gaps.

    -gappyout                Use automated selection on "gappyout" mode. This method only uses information based on gaps' distribution. (see User Guide).
    -strict                  Use automated selection on "strict" mode. (see User Guide).
    -strictplus              Use automated selection on "strictplus" mode. (see User Guide).
                             (Optimized for Neighbour Joining phylogenetic tree reconstruction).

    -automated1              Use a heuristic selection of the automatic method based on similarity statistics. (see User Guide).
                             (Optimized for Maximum Likelihood phylogenetic tree reconstruction).

    -resoverlap              Minimum overlap of a positions with other positions in the column to be considered a "good position". (see User Guide).
    -seqoverlap              Minimum percentage of "good positions" that a sequence must have in order to be conserved. (see User Guide).

    -w <n>                   (half) Window size, score of position i is the average of the window (i - n) to (i + n).
    -gw <n>                  (half) Window size only applies to statistics/methods based on Gaps.
    -sw <n>                  (half) Window size only applies to statistics/methods based on Similarity.
    -cw <n>                  (half) Window size only applies to statistics/methods based on Consistency.

    -sgc                     Print gap percentage count for columns in the input alignment.
    -sgt                     Print accumulated gap percentage count.
    -scc                     Print conservation values for columns in the input alignment.
    -sct                     Print accumulated conservation values count.
    -sfc                     Print compare values for columns in the selected alignment from compare files method.
    -sft                     Print accumulated compare values count for the selected alignment from compare files method.
    -sident                  Print identity statistics for all sequences in the alignemnt. (see User Guide).
------------------------------------------------------------------------------------------------------------------
EOF
}

if(!$out_seq&& !$mauveout){print "Error!\n\nPlease provide the output file\n";
	print $USAGE;
	exit;};
if(!$align){
	if(!$in){print "Error!\n\nPlease provide the input file aligned by mauve, or you can set --align and --path= to newly align specific sequences\n";
		print $USAGE;
		exit;};
	if(!$number){print "Error!\n\nSpecify the accurate number (-number) used in alignment or you could ignore this parameter by set --align parameter\n";
		print $USAGE;
		exit;};
}
if($min){
my $class=&typeOf($min);
if("$class" ne "int"){
print "Please give -min= an integer number.\n";
exit;
 }
}
#-------------------------------------------------------------------------------------------

if($align){
		undef $in; 
		undef $number;
        if(!$mauveout){
		       print "Error!\n\nPlease set the --mauve-out parameter!\n";
			   print $USAGE;
			   exit;
		}
        elsif(!$path){
		       print "Error!\n\nPlease set the --path parameter!\n";
			   print $USAGE;
			   exit;
		}
		else{
		$in=$mauveout;
		my @files=glob ("$path*.fasta");
		push @files,glob ("$path*.fas"); 
		push @files,glob ("$path*.fa"); 
		push @files,glob ("$path*.gb"); 
		my $filecom;
		$number=$#files+1; 
		print "Totla $number files detected!\nThe list of sequences will be aligned:\n";
		           foreach(@files){
				            $filecom.=" $_";
		                    print "$_\n"; 
		                            }
				 print "<===========Please re-check.============>\n\nKeep going?\n\[Press Enter/Ctrl+C\]\n";
				 my $go=<STDIN>;
					if(!$go){exit;}
					else{print "Aligning, please wait.\n";
					    system("./bin/progressiveMauve --output=$mauveout $filecom|tee mauve-screenout.log");
						open MAUVE,"<","mauve-screenout.log";
						while(<MAUVE>){print;}
					    }
                    					
		}

}

print "\n\n\n                  
							********************                  
							**HomBlocks start!**               
							********************\n
						Aligned fasta file is $in
					Number of the taxon species used in alignment is $number\n";

my $taxon=1;
my $file=1;
my $module;

#-------------------------------------------------------------------------------------------

open(HEAD, ">>head.tmp");
open(IN, "<$in")||die "Can't open $in:$!\n";
while(<IN>){
if($_=~m/^>/){
print HEAD "$_";
}
}
close(HEAD);

print "\n\n\nNow identifying the colinear blocks. Be patient\n\n\n";
open(TMP, "<head.tmp")||die "Can't open $in:$!\n";
while(<TMP>){
     
	   if($_=~m/^>\s$taxon:/){
	   $module.="$_";
	   $taxon++;
	         if($taxon==$number+1){
	                  open(OUT, ">module_$file.head") ;
	                  print OUT "$module";
					  close(OUT);
					  undef $module;
					  $taxon=1;
					  $file++;
					  }
			     }
       else{
	        undef $module;
	        $taxon=1;
	      }
}

unlink ("head.tmp");
print "Finished!\n\n\n";


#-------------------------------------------------------------------------------------------

my @head=glob("*.head");
my $temp_num=@head;
print "$temp_num colinear blocks were identified totally!\n\n\nNow extracting these sequences!\n\n\n";

foreach my $head(@head){
     my $head_module=$head;
	 $head_module=~s/\.head//;
	 print "$head_module\n";
     &extract($head,$in);
     unlink "$head";
	 my $temp_name=$head;
	 $temp_name=~s/head//g;
	 rename("$head.fasta","${temp_name}fasta");
}
print "\n\nSequences extraction complete!\n\n\n";

#-------------------------------------------------------------------------------------------

my @seq=glob("*.fasta");
   foreach my $seq(@seq){
        open(TMP2IN, "<$seq")||die "Can't open $in:$!\n";
        open(TMP2OUT, ">>$seq.rename")||die "Can't open $in:$!\n";
        while(<TMP2IN>){
		             if($_=~m/=/){next;}
		             if($_=~m/^>/){
					 my @array=split(/ [+|-] /,$_);
					 my @array2=split(/\\/,$array[$#array]);
					 my @array3=split(/\//,$array2[$#array2]);
					 $array3[$#array3]=~s/\.gb//g;
					 $array3[$#array3]=~s/\.fasta//g;
					 $array3[$#array3]=~s/\.fa\n/\n/g;
					 $array3[$#array3]=~s/\.fa\r\n//g;
					 $array3[$#array3]=~s/\.fas\n/\n/g;
					 $array3[$#array3]=~s/\.fas\r\n/\n/g;
					 $array3[$#array3]=~s/ /_/g;
					 print TMP2OUT ">$array3[$#array3]";
					 undef @array;
					 undef @array2;
					 undef @array3;
					 }
					 else {print TMP2OUT "$_";}
		             
		 }
close(TMP2IN);
close(TMP2OU);
  unlink ("$seq");
  rename("$seq.rename","$seq");
}

#-------------------------------------------------------------------------------------------

print "Now, trimming!\n\n\n";

my @trimed=glob("*.fasta");
foreach my $trimed(@trimed){
         if("$method" eq "Gblocks"){system("./bin/Gblocks $trimed out");}
		 if("$method" eq "trimAl"){system("./bin/trimal -in $trimed -out ${trimed}-gb -fasta -htmlout $trimed.html -automated1");}
		 if("$method" eq "BMGE"){system("java -jar ./bin/BMGE.jar -i $trimed -t DNA -s YES -of ${trimed}-gb -oh $trimed.html");}
		 if("$method" eq "noisy"){system("./bin/noisy $trimed");}
		 unlink ("$trimed");
}


#-------------------------------------------------------------------------------------------

if("$method" eq "Gblocks"){
my @gb=glob("*.fasta-gb");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){print GBOUT "$_";}
				  elsif(/^\w{10}\s/i){
				              $delete++;
				              $_=~s/\s//g;
							  print GBOUT "$_\n";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb.".out";
$temp_name2=~s/fasta-gb\.out/fasta/g;
rename("$gb.out","$temp_name2");
}}

if("$method" eq "trimAl"){
my @gb=glob("*.fasta-gb");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){print GBOUT "$_";}
				  elsif(/^[A|T|C|G|N|-]+\n/i){
				              $delete++;
				              print GBOUT "$_";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb;
$temp_name2=~s/fasta-gb/fasta/g;
rename("$gb.out","$temp_name2");
}}

if("$method" eq "BMGE"){
my @gb=glob("*.fasta-gb");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){print GBOUT "$_";}
				  elsif(/^[A|T|C|G|N|-]+\n/i){
				              $delete++;
				              print GBOUT "$_";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb;
$temp_name2=~s/fasta-gb/fasta/g;
rename("$gb.out","$temp_name2");
}}

if("$method" eq "noisy"){
my @gb=glob("*.fas");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){$_=~s/ //g;print GBOUT "$_";}
				  elsif(/^[A|T|C|G|N|-]+\n/i){
				              $delete++;
				              print GBOUT "$_";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb;
$temp_name2=~s/_out\.fas/\.fasta/g;
rename("$gb.out","$temp_name2");
}}
#-------------------------------------------------------------------------------------------

my @final=glob("*.fasta");
my $f_length=@final;
if ($f_length==$temp_num){
       print "All blocks extracted by Mauve have conserved sequences.\n\n\n";
}
else {print "Only $f_length blocks have conserved sequences.\n\n\n";}

my @fasta;
my $hehe=1;
foreach my $final(@final){
        
        if ($hehe>1){last;}
        else {
		open(HEHE, "<$final")||die "Can't open $in:$!\n";
		while(<HEHE>){
		if($_=~m/^>/){push @fasta, $_;}
		}
		close(HEHE);
 }
 $hehe++;
}

open(CAN,">>$out_seq")||die "Can'not open file";
my $character_length;
my $start=0;
my @PartitionFinder_text;
my @length_above_module;
foreach $fasta(@fasta){
          my @fastb=split(/ /,$fasta);
		  my $can_all;
		  if($method eq "trimAl"){print CAN "$fastb[0]\n";}
		  else{print CAN "$fastb[0]";}
  foreach $final(@final){
		  
          open(FILE,"<$final")||die"Can'not open file";
		  my $turnoff=0;
		  my $can;
          while(my $line=<FILE>){
		  if("$method" eq "Gblocks"){
		  if ($line eq $fasta){$turnoff=1;next;}
		  elsif($line ne "$fasta"&&$line=~m/>.*\n/){$turnoff=0;}
		  }
		  
		  if("$method" eq "trimAl"){
		  if ($line=~m/$fastb[0] \d+ bp\n/){$turnoff=1;next;}
		  elsif($line ne $fasta&&$line=~m/>.*\n/){$turnoff=0;}
		  }
		  
		  if("$method" eq "BMGE"){
		  if ($line eq $fasta){$turnoff=1;next;}
		  elsif($line ne "$fasta"&&$line=~m/>.*\n/){$turnoff=0;}
		  }
		  
		  if("$method" eq "noisy"){
		  if ($line eq $fasta){$turnoff=1;next;}
		  elsif($line ne "$fasta"&&$line=~m/>.*\n/){$turnoff=0;}
		  }
          if($turnoff){chomp $line;$can.=$line;}
		  
		   }
		  
		  if($min){if(length($can)<$min){next;}
		  elsif($fasta eq $fasta[0]){my $temp_name4=$final;$temp_name4=~s/\.fasta//;push @length_above_module,$temp_name4;}}
		 
		  
		  if($fasta eq $fasta[$#fasta]){
		  
          my $temp_name3=$final;
		  $temp_name3=~s/\.fasta//;
		  push @PartitionFinder_text,"$temp_name3 = ";
		  push @PartitionFinder_text,$start+1;
		  push @PartitionFinder_text,"-";
		  push @PartitionFinder_text,$start+length($can); 
		  push @PartitionFinder_text,";\n";
		  $start=$start+length($can);
		  }
 $can_all.=$can;

 }
  print CAN "$can_all\n";
$character_length=length($can_all);
undef @first_name;
}
close(CAN);
#----------------------------------------------------------------------------------------------
print "The final concatenated sequences was writen in $out_seq\n\n";
if($min){print "only ", $#length_above_module+1, " modules with length above $min bp:\n\n";
foreach(@length_above_module){print "$_\n";}
print "\n";}
print "The location of each extracted modules on the final concatenated seq:\n\n";
print @PartitionFinder_text;
print "\nThe concatenated length is $character_length bp\n\n";


if($PartitionFinder){
my $see=1;
mkdir partitionfinder_dir;
system("cp $out_seq partitionfinder_dir/");

open PIN,"<", "partitionfinder_dir/$out_seq"||die "Can not open $out_seq file in partitionfinder";
open POUT,">>", "partitionfinder_dir/seq.fasta"||die "Can not write to file seq.fasta";

while(<PIN>){
if($_=~m/^>/){print POUT ">seq_$see\n"; $see++;next; }
else{print POUT "$_";}
}
close(PIN);
close(POUT);
system("./bin/readal -in partitionfinder_dir/seq.fasta -out partitionfinder_dir/seq.phy -phylip");
&PartitionFinder_cfg();
system("python PartitionFinderV1.1.1/PartitionFinder.py partitionfinder_dir");
}


print "HomBlocks DATA PREPRATION COMPLETED! ENJOY IT!!\n\n\n";

#-----------------------------------------------------------------------------------------------

if($gbinput){
my @own_seq=&gb_gene_extract($gbinput);
open GBSEQ, ">>", "temp_gb_seq.out";
foreach(@own_seq){
       $_=~s/ //g;
	   print GBSEQ $_;
}
close(GBSEQ);
open SEQBLASTPRE, "<", "$out_seq";
my $another_count=0;
while(<SEQBLASTPRE>){
      if($another_count==0){print "The sequence number and seq title: \n";}
      if($_=~m/^>/){$_=~s/>//;$another_count++, print "$another_count","\t","$_\n";}
}
close(SEQBLASTPRE);
print "Which sequence will be used to blast?\n";
my $num_blast_seq=<STDIN>;
chomp $num_blast_seq;
$num_blast_seq=$num_blast_seq*2-1;
open SEQBLASTPRE2, "<", "$out_seq";
open SEQBLASTPRE3, ">>", "temp_db.out";
my $line_num;
while(<SEQBLASTPRE2>){
    if($line_num==$num_blast_seq-1){print SEQBLASTPRE3 $_;}
	if($line_num==$num_blast_seq){print SEQBLASTPRE3 $_;}
$line_num++;
	}
close(SEQBLASTPRE2);
close(SEQBLASTPRE3);
}
#-----------------------------------------------------------------------------------------------

sub extract{
my $biaotou=shift @_;
my $seq=shift @_;
my @liuyuan;
open IN,"<",$biaotou;
while(<IN>){
push @liuyuan,"$_";
}

foreach(0...$#liuyuan){

open OUT,"<",$seq;
open FASTA,">>","$biaotou.fasta";
my $turnoff=0;
while($line=<OUT>){
           
           if($line eq $liuyuan[$_]){$turnoff=1;
                                           print FASTA "$line";
                                           next;
                                                 }
	       elsif($line ne $liuyuan[$_]&&$line=~m/>.*\n/){$turnoff=0;}
		   if($turnoff){$line=~tr/BDHIKMNRSVWY/NNNNNNNNNNNN/;
		   print FASTA "$line";}	       
		   

}
close(OUT);
close(FASTA);
}
}


sub PartitionFinder_cfg{

open CFG, ">>", "partitionfinder_dir/partition_finder.cfg";

print CFG "
## ALIGNMENT FILE ##
alignment = seq.phy;

## BRANCHLENGTHS: linked | unlinked ##
branchlengths = linked;

## MODELS OF EVOLUTION for PartitionFinder: all | raxml | mrbayes | beast | <list> ##
##              for PartitionFinderProtein: all_protein | <list> ##
models = all;

# MODEL SELECCTION: AIC | AICc | BIC #
model_selection = BIC;

## DATA BLOCKS: see manual for how to define ##
[data_blocks]";

print CFG @PartitionFinder_text;

print CFG "

## SCHEMES, search: all | greedy | rcluster | hcluster | user ##
[schemes]
search = greedy;

#user schemes go here if search=user. See manual for how to define.#";
close(CFG);
}
#------------------------------------------------------------------------------------------------------------------

sub typeOf{
	my $val = shift;

	use Carp qw(confess);
	if ( ! defined $val ) {
		return 'null';
	} elsif ( ! ref($val) ) {
		if ( $val =~ /^-?\d+$/ ) {
			return 'int';
		} elsif ( $val =~ /^-?\d+(\.\d+)?$/ ) {
			return 'float';
		} else {
			return 'string';
		}
	} else {
		my $type = ref($val);
		if ( $type eq 'HASH' || $type eq 'ARRAY' ) {
			return 'array';
		} elsif ( $type eq 'CODE' || $type eq 'REF' || $type eq 'GLOB' || $type eq 'LVALUE' ) {
			return $type;
		} else {
			# Object...
			return 'obj';
		}
	}
}
#------------------------------------------------------------------------------------------------------------------

sub gb_gene_extract {
my $gbin=shift @_;
my $wholeseq;
open GBIN, "<", $gbin;
my $print_off; 
my @head;
while(<GBIN>){

 if($_=~m/^ORIGIN/){$print_off=1;next;}
 if($print_off==1&&$_=~m/^\/\//){undef $print_off;next;}
 elsif($print_off==1){$_=~s/^ +\d+ //g;$_=~s/ //g;chomp $_;$wholeseq="$wholeseq".uc("$_");}
 
}
close(GBIN);

open GBIN2, "<", $gbin;
my $gene_symble_off;
my $start;
my $end;
my $symble;
my $if_complement;
my %seq_matrix;
while(<GBIN2>){

 if($_=~m/^     gene            /){my @slice1=split(/            /,$_);
                                  if($slice1[1]=~m/complement/){$if_complement=1;}
								   else{$if_complement=0;}
								   #print "$if_complement\n";
                                   $slice1[1]=~m/(\d+)\.\.(\d+)/;
								   
								   #print "$1\t$2\n";
								   $start=$1;
								   $end=$2;
                                   $gene_symble_off=1;
								   next;
								   }
 if($gene_symble_off&&$_=~m/\/gene="\w.*"/){
                                   $_=~m/\/gene="(\w.*)"/;
                                   #print "$1\n";
                                   $symble=$1;undef $gene_symble_off;}
#unshift @{$seq_matrix{$symble}}, $symble;
#unshift @{$seq_matrix{$symble}}, $start;
#unshift @{$seq_matrix{$symble}}, $end;
#foreach (@{$seq_matrix{$symble}}){print "$_\n"};
$seq_matrix{$symble}[0]=$symble;
$seq_matrix{$symble}[1]=$start;
$seq_matrix{$symble}[2]=$end;
$seq_matrix{$symble}[3]=$if_complement;
#print "$if_complement\n";
 }
 @k=keys%seq_matrix;
 my @combine_seq; 
 my $temp_gene_seq;
 foreach (@k){
             #print "$_\n";
			 if($seq_matrix{$_}[3]==1){
			 #print "get!/n";
             $temp_gene_seq=substr($wholeseq,$seq_matrix{$_}[1]-1,$seq_matrix{$_}[2]-$seq_matrix{$_}[1]+1);
			 $temp_gene_seq = reverse("$temp_gene_seq");
			 $temp_gene_seq=~tr/ACGT/TGCA/;
			 }
			 elsif($seq_matrix{$_}[3]==0){
			 #print "get2!/n";
			 $temp_gene_seq=substr($wholeseq,$seq_matrix{$_}[1]-1,$seq_matrix{$_}[2]-$seq_matrix{$_}[1]+1);
			 }
			 push @combine_seq, ">$seq_matrix{$_}[0]\n";
			 push @combine_seq,"$temp_gene_seq\n";
             #print "$_\n";
             #print "@{$seq_matrix{$_}}\n";
 }

return @combine_seq[2..$#combine_seq];
# my $long=$end-$head+1;
# my $split=substr($lines,$head-1,$long);

}
