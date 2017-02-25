# What is HomBlocks?
For the purpose of saving time of preparation of sequence matrix derived from organelle genomes that would be utilized in phylogeny analysis. We developed a rapid and accurate method for this sequence matrix construction. In this pipeline, the core conserved fragment (usually the conserved coding genes) will be picked out and integrated into a long sequence from the same genome. This method avoids the bothering sequence alignment procedure of every single gene and can generate phylogeny informative and high quality data matrix. Usually, instead of a few weeks of manual work, it only takes a few minutes or hours to construct the HomBlocks matrix among less than 20 organelle genomes. In addition, HomBlocks produces circos configure files for visualization, sequence partitioning strategy and best-fit DNA substitution model, which are important in downstream phylogeny analysis.

#Installation
HomBlocks is a pipeline that implemented by Perl 5. 

There is no need of external installation for HomBlocks.

All the dependencies external executable files are placed under bin directory.

git clone https://github.com/fenghen360/HomBlocks.git
or download the zip compressed files into your work directory

//Reasons why alignment cannot be established using whole organelle genomes

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/alignment2.png)
