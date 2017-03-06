What is HomBlocks?
=======
　　HomBlocks is a new and highly efficient pipeline that used homologous blocks searching method to construct multi-gene alignment. It can automatically recognize locally collinear blocks among organelle genomes and excavate phylogeny informative regions to construct multi-gene involved alignment in few hours.<br/>
　　Because the traditional way of construction multi-gene alignments utilized in organelle phylogenomics analyses is a time-consuming process.Therefore, for the purpose of improving the efficiency of sequence matrix construction derived from multitudes of organelle genomes, we developed a time-saving and accurate method that would be utilized in phylogenomics studies. <br/>
　　In this pipeline, the core conserved fragment (conserved coding genes, functional non-coding regions and rRNA) will be picked out and integrated into a long sequence from the same genome. This method avoids the bothering sequence alignment procedure of every single gene and can generate phylogeny informative and high quality data matrix. Usually, instead of week-long manual work, it only takes less than an hour to construct the HomBlocks matrix with around two dozens of organelle genomes. In addition, HomBlocks produces circos configure files for visualization, sequence optimal partition schemes and models of sequence evolution for RAxML, which are important in downstream phylogeny analysis.<br/>

Traditional way for construction of multi-gene alignment from organelle genomes
-------
　　Almost all studies regarding with organelle genomics were accustomed to making phylogeny analyses by taking advantage of multiple genes in improvements of phylogentic resolution. But, usually, every single set of orthology genes was need to be pre-aligned, then concatenation was performed among these common aligned genes.


Reasons why alignment cannot be established using whole organelle genomes
-------
![image](https://github.com/fenghen360/Tutorial/blob/master/pic/alignment2.png)


##Workflow
![image](https://github.com/fenghen360/Tutorial/blob/master/pic/workflow.png)

##Installation
　　HomBlocks is a pipeline that implemented by Perl 5. <br/>
　　There is no need of external installation for HomBlocks.<br/>
　　All the dependencies external executable files are placed under bin directory.<br/>
　　git clone https://github.com/fenghen360/HomBlocks.git　or download the zip compressed files into your work directory<br/>


