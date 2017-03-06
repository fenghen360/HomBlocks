# What is HomBlocks?

　　HomBlocks is a new and highly efficient pipeline that used homologous blocks searching method to construct multi-gene alignment. It can automatically recognize locally collinear blocks (LCB) among organelle genomes and excavate phylogeny informative regions to construct multi-gene involved alignment in few hours.<br/>
　　Because the traditional way of construction multi-gene alignments utilized in organelle phylogenomics analyses is a time-consuming process.Therefore, for the purpose of improving the efficiency of sequence matrix construction derived from multitudes of organelle genomes, we developed a time-saving and accurate method that would be utilized in phylogenomics studies. <br/>
　　In this pipeline, the core conserved fragment (conserved coding genes, functional non-coding regions and rRNA) will be picked out and integrated into a long sequence from the same genome. This method avoids the bothering sequence alignment procedure of every single gene and can generate phylogeny informative and high quality data matrix. Usually, instead of week-long manual work, it only takes less than an hour to construct the HomBlocks matrix with around two dozens of organelle genomes. In addition, HomBlocks produces circos configure files for visualization, sequence optimal partition schemes and models of sequence evolution for RAxML, which are important in downstream phylogeny analysis.<br/>

## Traditional way for construction of multi-gene alignment from organelle genomes

　　Almost all studies regarding with organelle genomics were accustomed to making phylogeny analyses by taking advantage of multiple genes in improvements of phylogentic resolution. But, usually, every single set of orthology genes was need to be pre-aligned, then concatenation was performed among these common aligned genes. Though some softwares, like SequenceMatrix, can facilitate the procedure of sequence extraction or concatenation, to constrcut multi-gene alignments derived from organelle genomes is a complex process and prone to induce artificial errors. Despite that, the most concerning point for researches is how long this alignment procedure took. In general, with the help of some bioinformatics tools, it will take at least two weeks to make genome-wide alignments using common genes among 30 higher plant chloroplast genomes (about 150kb long with at least 100 common genes). Thus, the common phenomenon exists in papers of plant chloroplast genomes that the number of genes used in phylogeny were decreased to below 70. And reseachers have to be patient and cautious, because single gene alignment with artificial errors can lead to undetectable misplacement in the final alignments. Generally speaking, organelle phylogenomic analysis provides exact tools to detect genetic relationships, but the construction of multi-gene alignments does not sound 
convenient. <br/>


## Reasons why alignment cannot be established using whole organelle genomes
　　The evolution of organelle genomes is dynamic and diverse in gene content, structure and sequnce divergence. Thus, basically speaking, they cannot be aligned directly using the whole genome sequences as shown by picture below.<br/>

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/alignment2.png)<br/>
　　This is the result picture from Mauve by comparison of plastid genomes of three green algae. As we can see, there was a large invert frament in Ulva sp. when comparing with other sequences (arrow B), and gene content, intergenic region length were also different (arrorw C). Similarly, number of gene introns among the genomes were different (arrow A).  The most direct consequence is that they exhibited in different length (arrow D). For aligners, these characteristics can lead to fatal error or being corrupted. <br/>
　　Organelle genomes within intraspecies are usually conserved both in length and structure. So, in some cases, they can be aligned directly. But in nine cases of ten, researches of organelle genomes focus on interspecies level, which means the direct alignment is difficult to realize.<br/>
   
## Methodology
The working flow diagram was shown below.<br/>

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/workflow.png)<br/>

　　HomBlocks utilizes progressiveMauve, which applies anchored alignment algorithm, to identify locally collinear blocks (LCBs) shared by organelle genomes (chloroplast and mitochondrial genomes). <br/>
The co-exist LCBs among all organelle genomes will be extracted and trimmed to screen out phylogeny informative regions.<br/> 　　HomBlocks offers four different methods for LCBs trimming: Gblocks, trimAl, noisy and BMGE. Without settings, the default trimming method is Gblocks. <br/>
　　The final alignment that was composed of trimmed LCB could be used in downstream analysis. Additional parameters were provided for users to select the best fit DNA substitution model and optimal partition schemes and models of sequence evolution for RAxML with the final alignment by PartitionFinder. At the same time, circos configure files will be generated via circoletto (Darzentas, 2010) for visualization to explore which gene was involved in the final alignment.<br/>


## Installation
　　HomBlocks is a pipeline that implemented by Perl 5. <br/>
　　No external installation is needed for HomBlocks.<br/>
　　All the dependencies external executable files are placed under bin directory.<br/>
　　git clone https://github.com/fenghen360/HomBlocks.git　<br/>
　　Or download the zip compressed files into your work directory<br/>
  

```bash
# Decompressing files
unzip HomBlocks-master.zip

# Note that Homblocks.pl is the main program, you can check it's usage by
perl Homblocks.pl

# Check wether programs in bin directory are executable. if they are not, change their permission.
cd HomBlocks-master
cd bin
chmod 755 *

# make programes in PartitionFinderV1.1.1 executable
cd ..
cd PartitionFinderV1.1.1
chmod 755 
chmod 755 PartitionFinder*
cd programs
chmod 755 *
cd ..
cd partfinder
chmod 755 *

```

### Required software

1. perl with version above 5
2. java with version above 1.7
3. python with version above 2.7
4. circos (optimal)
    1. circos is not easy to install on a linux server without root permissions. If you want install to visualize the genes involved in the alignments. You can use perl scipts cpanm.pl (```http://xrl.us/cpanm```) to install perl modules. Otherwise, my advice is to do this visualization on circoletto webserver http://tools.bat.infspire.org/circoletto/ by input of whole genome sequence and a set of every single gene sequence, respectively. <br/>
    

## Tutorial

　　HomBlocks is not complex to use. What it needs are fasta or gebank files (fasta, fas, fa or gb suffix). You must put all these sequences **in a directory**. Like these test sequnces that were put in **Xenarthrans/fasta**.<br/>

To begin with, you can check the usage of HomBlocks without any parameters.<br/>

```bash
# check usage
perl HomBlocks.pl

# The print of screen should be like this
usage: ./HomBlocks.pl <parameters>
         
parameters:
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
                -gb=                                  genbank file provided to detect how many genes were used to construct finaly alignment.

                -help/h                               Print the usage.


```
<br/>
<br/>
#### Running with 36 Xenarthrans mitochondrial genomes as an example

This dataset of example running was referred to this paper:<br/>
**Gibb, G. et al. (2016). Shotgun mitogenomics provides a reference phylogenetic framework and timescale for living xenarthrans. Molecular Biology and Evolution, 33(3), 621-642.**<br/>

Example run with parameters like this:<br/>

```bash
perl HomBlocks.pl --align --path=/public/home/mgb217/HomBlocks/Xenarthrans/fasta/ -out_seq=Xenarthrans.output.fasta  --mauve-out=Xenarthrans.mauve.out
```
<br/>

The meanings of these parameters could be found in the usage of HomBlocks. It should be noted that ```--align``` and ```--path``` must be set at same time.<br/>
Because ```--align``` means that you have no mauve alignments result file for the first time, so set this parameter to run progressiveMauve for LCB detection. Meanwhile,  ```--path``` parameter will define the absolute path of directory in where you put your sequences.<br/>
<br/>
<br/>
Next, HomBlocks will detect the sequences in the directory you defined.<br/>
The printscreen should be like this:<br/>

```bash
Totla 36 files detected!
The list of sequences will be aligned:
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_pygmaeus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_torquatus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_tridactylus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_variegatus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_variegatus_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_centralis.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_chacoensis.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_tatouay.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_unicinctus_ISEM_T-2291.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_unicinctus_MNHN_1999-1068.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Calyptophractus_retusus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Chaetophractus_vellerosus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Chaetophractus_villosus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Chlamyphorus_truncatus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Choloepus_didactylus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Choloepus_didactylus_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Choloepus_hoffmanni.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cyclopes_didactylus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_hybridus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_kappleri.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_novemcinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_novemcinctus_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_pilosus_LSUMZ_21888.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_pilosus_MSB_49990.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_sabanicola.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_septemcinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_yepesi.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Euphractus_sexcinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Myrmecophaga_tridactyla.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Priodontes_maximus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tamandua_mexicana.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tamandua_tetradactyla.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tamandua_tetradactyla_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tolypeutes_matacus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tolypeutes_tricinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Zaedyus_pichiy.fasta
<===========Please re-check.============>

Keep going?
[Press Enter/Ctrl+C]

```

If the number of these sequences is matched, print **Enter** key to continue. Otherwise, print **Ctrl+C** to abort and check whether the suffix of these sequences is correct.<br/>

When the LCB detection process run is complete, HomBlocks will start triming LCBs step.<br/>
After trimming, all filtered module sequences of each species will be concatenated together.<br/>

```bash
                                                        ********************                  
                                                        **HomBlocks start!**               
                                                        ********************

                                                Aligned fasta file is Xenarthrans.mauve.out
                                        Number of the taxon species used in alignment is 36



Now identifying the colinear blocks. Be patient


Finished!


1 colinear blocks were identified totally!


Now extracting these sequences!


module_1


Sequences extraction complete!


Now work with Gblocks!



36 sequences and 20823 positions in the first alignment file:
module_1.fasta

module_1.fasta
Original alignment: 20823 positions
Gblocks alignment:  15170 positions (72 %) in 125 selected block(s)

All blocks extracted by Mauve have conserved sequences.


The final concatenated sequences was writen in Xenarthrans.output.fasta

The location of each extracted modules on the final concatenated seq:

module_1 = 1-15170;

The concatenated length is 15170 bp

HomBlocks DATA PREPRATION COMPLETED! ENJOY IT!!

```
#### Output files

##### 1. The most important result

This simple run was finished resulting with alignment file named **Xenarthrans.output.fasta**<br/>
Sequences in **Xenarthrans.output.fasta** were already aligned, you can check it by aligners like MEGA, clustalx or UGENE.

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/ugene.png)<br/>

##### 2. The LCB trimming result named module_X.fasta-gb.html and module_X.fasta
And the LCB trimming results: <br/>
　　　　　　　**module_1.fasta** (timmed LCB sequnce) <br/>
　　　　　　　**module_1.fasta-gb.htm** (trimming results from Glbocks. In this case，only one LCB was detectable) <br/>
Your can review the trimming results through web browser.<br/>

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/Gblock.png)<br/>

##### 3. A LCB detection result derived from progressiveMauve

**Xenarthrans.mauve.out**<br/>
　　Please keep this file!(Of course, the name of this file was defined by users)<br/>
In other cases, running HomBlocks with a series of green plastid genomes which were complex in structure and gene content will result in a dozen of LCBs. Some of them would pass the trimming procedure, other would fail. And the number of LCBs can be adjusted by add the parameter ```-min=``` to filter by length.<br/>
　　If you want to make adjustment of LCB number involved in final alingment, you can filter out them with shourt lenthg (for example, 200 bp). You don't need to rerun HomBlocks with progressiveMauve, if you keep **Xenarthrans.mauve.out** (in this case).<br/>

The commond line should also be adjusted like this:<br/>

```
perl HomBlocks.pl -in=Xenarthrans.mauve.out -out_seq=Xenarthrans.output.fasta -number=36 -min=200 -method=Gblocks
```
<br/>
Note: 
```
-number=36
``` 
indicated the number of species used in this analysis.　<br/><br/>
```
-in=Xenarthrans.mauve.out
```
HomBlocks will reuse Xenarthrans.mauve.out as input to do co-exist LCB detection with length filter criteria (-min=200). <br/>

##### 4. Results with setting --PartitionFinder parameter
To run HomBlocks with parameter ```--PartitionFinder``` will take sequence partition strategy and best-fit DNA substitution models of modules (LCB) using PartitionFinder. HomBlocks will build a directory named partitionfinder_dir. The text result was placed under directory named analysis.

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/best.png)<br/><br/>

Here an example of the content of best_scheme.txt<br/>

```bash
Settings used

alignment         : ./seq.phy
branchlengths     : linked
models            : GTR+I+G, GTR+G
model_selection   : bic
search            : greedy


Best partitioning scheme

Scheme Name       : step_8
Scheme lnL        : -241508.035996
Scheme BIC        : 484605.330493
Number of params  : 144
Number of sites   : 62101
Number of subsets : 4

Subset | Best Model | Subset Partitions              | Subset Sites                   | Alignment                               
1      | GTR+I+G    | module_10, module_11, module_12, module_13, module_2, module_8 | 1-1217, 1218-1846, 1847-5466, 5467-7193, 7194-12794, 39284-39336 | ./analysis/phylofiles/b223f9fb0607d180c62e998e0640f084.phy
2      | GTR+I+G    | module_3, module_6, module_9   | 12795-13385, 28709-32188, 39337-62101 | ./analysis/phylofiles/1fe695cc374da03d9393032bc6b129fc.phy
3      | GTR+I+G    | module_4                       | 13386-28648                    | ./analysis/phylofiles/2c9c71d29cc35eb4108311a57b96f1b4.phy
4      | GTR+I+G    | module_5, module_7             | 28649-28708, 32189-39283       | ./analysis/phylofiles/d5259e194f9986883883203b81c0ba0c.phy


Scheme Description in PartitionFinder format
Scheme_step_8 = (module_10, module_11, module_12, module_13, module_2, module_8) (module_3, module_6, module_9) (module_4) (module_5, module_7);

RaxML-style partition definitions
DNA, p1 = 1-1217, 1218-1846, 1847-5466, 5467-7193, 7194-12794, 39284-39336
DNA, p2 = 12795-13385, 28709-32188, 39337-62101
DNA, p3 = 13386-28648
DNA, p4 = 28649-28708, 32189-39283


### Notes on running the program:

The ogcleaner.py script is all-inclusive and will do everything for you.
You may save time doing some of the following.
```






## Acknowledgements

The authors would like to thank:

1. Chengjie Chen (College of Horticulture, South China Agricultural University)
2. Penghao Yu (Institute of Genetics and Developmental Biology, Chinese Academy of Sciences)
3. Xiwen Xu (College of informatics, HuaZhong agricultual university)
