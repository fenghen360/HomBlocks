# What is HomBlocks?

　　HomBlocks is a new and highly efficient pipeline that used homologous blocks searching method to construct multi-gene alignment. It can automatically recognize locally collinear blocks among organelle genomes and excavate phylogeny informative regions to construct multi-gene involved alignment in few hours.<br/>
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
　　There is no need of external installation for HomBlocks.<br/>
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

　　HomBlocks is not complex to use. What it needs are fasta or gebank files (fasta, fas, fa or gb suffix). You must put all these sequences **in a directory**. Like these test sequnces which were put in **Xenarthrans/fasta**.<br/>

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
#### Running with 36 Xenarthrans mitochondiral genomes as an example

This dataset of example running was referred to this paper:<br/>
**Gibb, G. et al. (2016). Shotgun mitogenomics provides a reference phylogenetic framework and timescale for living xenarthrans. Molecular Biology and Evolution, 33(3), 621-642.**<br/>

Example run with parameters like this:<br/>

```bash
perl HomBlocks.pl --align --path=~/HomBlocks/Xenarthrans/fasta/ -out_seq=Xenarthrans.output.fasta  --mauve-out=Xenarthrans.mauve.out
```



To train a model you must use the ```train``` positional argument.

```bash
# Get a dataset from OrthoDB.
# This can be done via the OrthoDB website, or you can use wget if you want to query their APIs directly as shownn below
# this file is written to disk with the name 'universal.singlecopy0.9.fasta' as seen in the wget options
wget -O arthro.universal0.8.single0.8.fasta "http://orthodb.org/fasta?query=&level=6656&species=6656&universal=0.8&singlecopy=0.8&limit=100000"

# Run the model training script on the included test dataset (a very small subset of OrthoDB data)
# This script will take care of everything for you after you have a dataset from OrthoDB, includeing:
#   1. Parsing the sequences into their OrthoDB Groups
#   2. Generate false-positive homology clusters from the true-positive homology clusters
#   3. Align the clusters using MAFFT
#   4. Featurize the clusters
#   5. Train a filtering model
python bin/ogcleaner.py train --orthodb_fasta arthro.universal0.8.single0.8.fasta --threads 10 --clean
```

Using the ```--threads NUM_FLAGS``` flag will multithread the program and make it go faster.

This script will train a model for you and save the model to disk to be used in the following script.
The model is saved to disk to default locations but can be set by the ```--trained_model_dir``` and ```--save_prefix``` arguments.
It also generates lots of intermediary files that can be removed if you do not wish to keep them.
Use the ```make clean``` command to remove all intermediary files but still retain the trained models.
You can also use the ```--clean``` to remove the log files as you go.
It is highly suggested that you run with the ```--clean``` option.
Note that this command only removes the default folders, if you specify your own folders during runtime they must be manually deleted.
If you need to rebuild any of the packaged software (Aliscore, MAFFT, etc.) you can run ```make deepclean``` and it will delete all compiled versions of the program.

You can use your own orthology group data to train the model as well.
Simply supply a FASTA file that contains all orthology groups.
Each entry in the FASTA requires an ID that is unique to its respective orthology group.
Use the ```--og_field_pos``` to provie the 0-based index of the orthology group IDs during the training phase.

### Filtering using a trained model

```bash
# This will use the trained model in created in the previous step.
# It will filter the orthodb fasta files, all clusters should come back as H (homology clusters).
python bin/ogcleaner.py classify --fasta_dir train_orthodb_groups_fasta/ --model trained_model/filter --threads 10
```

You now have a filtered set of orthology clusters!

#### Using Your Own Data
To filter your own data, you must have one FASTA file that corresponds to each putative orthology cluster.
The FASTA file must have all protein sequences that belong to that cluster.
This can be generated by using ```scripts/gen_clusters_from_good_proteins.py``` to generate these FASTA files from OrthoMCL files.
Running the following will generate the FASTA cluster files and then run the classification step on them.

```bash
# Generate the FASTA cluster files from OrthoMCL files
python scripts/gen_clusters_from_good_proteins.py --groups groups.txt --proteins goodProteins.fasta --out fasta_cluster/

# Now run the filtering on these clusters
python bin/ogcleaner.py classify --fasta_dir fasta_cluster/ --model trained_model/filter --threads 10
```

### Output files

The results of the filtering will be output into a file called ```results.txt```.
To use these results in conjunction with OrthoMCL, use ```scripts/filter_orthomcl_output.py``` to filter your OrthoMCL ```groups.txt``` file.

#### Using Pre-Trained Models

A pre-trained model is provided in the repository.
Use the prefix ```pretrained_models/pretrained_filter``` while using OGCleaner in classify mode.

### Testing your training dataset

We have also included the ability to reproduce the plots in our paper and for you to be able to validate the effectiveness of your trained models.
This includes doing bootstrap analysis for each model with all features and for each individual feature using a neural network.
To run these tests and generate the plots, use the ```--test``` flag when

```bash
python bin/ogcleaner.py train --orthodb_fasta data/arthro.universal.singlecopy0.9.fasta --test
```

### Notes on running the program:

The ogcleaner.py script is all-inclusive and will do everything for you.
You may save time doing some of the following.

```
  --featurize_only      Only featurize the data, no testing or model training.
  --featurized_data FEATURIZED_DATA
                        Skip all steps and use the pickled, featurized data.
  --test_only           Only perform validation of models and features, do not
                        train final models. If --featurized_data is not set,
                        it will featurize your data and a OrthoDB fasta is
                        required.
```

## Acknowledgements

The authors would like to thank:

1. Chengjie Chen (College of Horticulture, South China Agricultural University)
2. Penghao Yu (Institute of Genetics and Developmental Biology, Chinese Academy of Sciences)
3. Xiwen Xu (College of informatics, HuaZhong agricultual university)
