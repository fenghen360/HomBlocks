#!/usr/bin/perl
#
#AUTHOR
#Guiqi Bi :fenghen360@126.com
#VERSION
#ROGP v0.1
#COPYRIGHT & LICENCE
#This script is free software; you can redistribute it and/or modify it.
#This  script is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability or fitness for a particular purpose.

my $USAGE = 	"\nusage: ./ROGP.pl <parameters>
	 	\nparameters:
		-in=<file>         Genome alignment outputfile derived from Muave. If you set --align, ignore this input parameter.
		-number=<int>      Number of taxa used in aliggment (should be precious). If you set --align, ignore this input parameter.
		--align            If you want to align sequences by mauve, add this parameter (Default: progressiveMauve).
		                   Then you should split every sequence into a single fasta file. Suffix must be .fasta
		--path=            Absolute path to directory where you put in fasta sequences.
		--mauve-out=       The output file produced by mauve (Absolute path). If you set --align parameter.
		-help              Print the usage.\n";
		

#-------------------------------------------------------------------------------------------
#提取参数
foreach my $paras (@ARGV){
	if ($paras=~/in/){
		$in=(split "=", $paras)[1];
	}
	if ($paras=~/number/){
		$number=(split "=", $paras)[1];
	}
	if ($paras=~/help/){
		print $USAGE;
	}
	if ($paras=~/align/){
	    $align=1;
	}
	if ($paras=~/path/){
		$path=(split "=", $paras)[1];
	}
	if ($paras=~/mauve-out/){
		$mauveout=(split "=", $paras)[1];
	}
}
#-------------------------------------------------------------------------------------------
#参数检验
if($align){
		undef $in; #如果设置了align,就清空$in和$number
		undef $number;
        if(!$mauveout){
		       print "Please set the --mauve-out= parameter!\n";#检查是否设置了--mauve-out参数
			   exit;
		}
        elsif(!$path){
		       print "Please set the --path= parameter!\n";#检查是否设置了path参数
			   exit;
		}
		else{
		$in=$mauveout; #把mauveout回传给$in
		my @files=glob "$path*.fasta";  #匹配fasta文件并保存到数组里
		my $filecom;
		$number=$#files+1; #回传文件数量给number变量
		print "Totla $number files detected!\nThe list of sequences will be aligned:\n";
		           foreach(@files){
				            $filecom.=" $_";
		                    print "$_\n";  #打印文件进行检验
		                            }
				 print "<===========Please re-check.============>\n\nKeep going?\n\[Enter press/Ctrl+C\]\n";
				 my $go=<STDIN>; #标准输入来决定程序是否进行下去
					if(!$go){exit;}
					else{print "Aligning, please wait.\n";
					    `./progressiveMauve --output=$mauveout $filecom|tee mauve-screenout.log`;
						open MAUVE,"<","mauve-screenout.log";
						while(<MAUVE>){print;}
					    }
                    					
		}

}

print "\n\nROGP started!\n\nAligned fasta file is $in\nNumber of the taxon species used in alignment is $number\n";

my $taxon=1; #记录fasta标头识别数字
my $file=1; #用于输出模块标头的head
my $module;

#-------------------------------------------------------------------------------------------
#首先提取fasta标头
open(HEAD, ">>head.tmp");
open(IN, "<$in")||die "Can't open $in:$!\n";
while(<IN>){
if($_=~m/^>/){
print HEAD "$_";
}
}
close(HEAD);

print "Identify the colinear blocks. Be patient\n\n\n";
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

`rm head.tmp`;
print "Finished!\n\n\n";


#-------------------------------------------------------------------------------------------
#抽取序列并修改文件名
my @head=glob("*.head");
my $temp_num=@head; #temp_num临时记录
print "$temp_num colinear blocks were identified totally!\nNow extracting these sequences!\n\n\n";
foreach my $head(@head){
     
	 &extract($head,$in);
     `rm $head`;
      }
	  
`rename .head.fasta .fasta *.fasta`;

#写了个子程序用来提取序列，直接拿的g.pl进行的修改
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
		   if($turnoff){print FASTA "$line";}	       
		   

}
close(OUT);
close(FASTA);
}
}
#-------------------------------------------------------------------------------------------
#改每个模块序列的标头，否则太长,Gblock无法处理,并处理每个模块序列尾部的=号

my @seq=glob("*.fasta");
   foreach my $seq(@seq){
        open(TMP2IN, "<$seq")||die "Can't open $in:$!\n";
        open(TMP2OUT, ">>$seq.rename")||die "Can't open $in:$!\n";
        while(<TMP2IN>){
		             if($_=~m/=/){next;}
		             if($_=~m/^>/){
					 my @array=split(/ [+|-] /,$_);
					 my @array2=split(/\\/,@array[$#array]);
					 my @array3=split(/\//,@array2[$#array2]);
					 @array3[$#array3]=~s/\.fasta//g;
					 print TMP2OUT ">@array3[$#array3]";
					 undef @array;
					 undef @array2;
					 undef @array3;
					 }
					 else {print TMP2OUT "$_";}
		             
		 }
close(TMP2IN);
close(TMP2OU);
  `rm $seq`;
}
`rename .fasta.rename .fasta *.rename`;





#-------------------------------------------------------------------------------------------
#使用Gblocks进行序列处理,需要将Gblocks添加至环境变量，也可以再设置参数，填写Gblock的位置,等去看看Gblock是否有没有交互的，好直接加参数进去
print "Now work with Gblock!\n\n\n"	;

my @trimed=glob("*.fasta");
foreach my $trimed(@trimed){
         `./Gblocks $trimed out`;
		 `rm $trimed`;
}


#-------------------------------------------------------------------------------------------
#处理gb后缀的结果文件
#perl -e '$gb=shift;open GB,$gb;while(<GB>){if(/^>/){print "$_";}if(/^[A|T|C|G|N]{10}\s/i){$_=~s/\s//g;print "$_";}}' block20.fasta-gb > block20-gb

my @gb=glob("*.fasta-gb");
foreach my $gb(@gb){
        my $delete=0; #设置个阈值，如果没有匹配到任何ATCG的话，就直接略过，并删掉产生文件
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){print GBOUT "$_";}
				  elsif(/^[A|T|C|G|N]{10}\s/i){
				              $delete++;
				              $_=~s/\s//g;
							  print GBOUT "$_\n";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){`rm $gb.out`;}
`rm $gb`;
}

`rename fasta-gb.out fasta *.fasta-gb.out`;



#-------------------------------------------------------------------------------------------
#最后合并文件,报告提取出多少模块，和总序列长度
my @final=glob("*.fasta");
my $f_length=@final;
if ($f_length==$temp_num){
       print "All blocks extracted by Mauve have conserved sequences.\n\n\n";
}
else {print "Only $f_length blocks have conserved sequences.\n\n\n";}
#先建一个数组
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

open(CAN,">>all-sequence.fasta")||die"Can'not open file";
my $character_length;

foreach $fasta(@fasta){
          my $can_all; #用来连接一个物种的序列
		  print CAN "$fasta";
  foreach $final(@final){
          open(FILE,"<$final")||die"Can'not open file";
		  my $turnoff=0; #用来判断是否连接
		  my $can; #用来连接序列
          while(my $line=<FILE>){
		  if ($line eq $fasta){$turnoff=1;next;}
		  elsif($line ne $fasta&&$line=~m/>.*\n/){$turnoff=0;}
          if($turnoff){chomp $line;$can.=$line;}
		   }
 $can_all.=$can;

 }
  print CAN "$can_all\n";
$character_length=length($can_all);
}
close(CAN);


print "The final concatenated sequences was writen in all-sequence.fasta\n\n";
print "The concatenated length is $character_length bp\n\n";
print "ROGP DATA PREPRATION COMPLETED! ENJOY IT!!\n\n\n";














