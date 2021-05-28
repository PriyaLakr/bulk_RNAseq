# RNAseq analysis workflow

# Quality control
Start with quality checking of the RNAseq fastq files. Commonly used tools include [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) [MultiQC](https://multiqc.info)

`bash scripts/pl_qc.sh`

# Trimming adaptors 
QC may or may not be followed by adaptor trimming. Commonly used tool is [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

`bash scripts/pl_trim.sh`

QC should also be performed after trimming the sequences!

# Alignment 
Multiple alignment tools are there in this world of bioinformatics. We will use here [star](https://github.com/alexdobin/STAR). 

`pl_STARindexgen.sh`
`pl_STARalign.sh`

Alignment step is tricky. Always read carefully the documentation before setting up any advanced paramaeters. This step can drastically affect downstream analyses.

# Read Count
Cool, we are done with alignment. We will now move to counting those alignments in a meaningful way. 
Two tools for counting reads are [featurecounts]() and [HTSeq Count]....

Only these two?? Still reading....

# Differential gene expression analysis 


