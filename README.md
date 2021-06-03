# RNAseq analysis workflow (Under development)

# Quality control
Start with quality checking of the RNAseq fastq files. Commonly used tools include [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) [MultiQC](https://multiqc.info)

`bash scripts/pl_qc.sh [options]`

# Trimming adaptors 
QC may or may not be followed by adaptor trimming. Commonly used tool is [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

`bash scripts/pl_trim.sh [options]`

QC should also be performed after trimming the sequences!

# Alignment 
Multiple alignment tools are there in this world of bioinformatics. We will use here [star](https://github.com/alexdobin/STAR). 

`bash scripts/pl_STARindexgen.sh [options]`

`bash scripts/pl_STARalign.sh [options]`

Alignment step is tricky. Always read carefully the documentation before setting up any advanced paramaeters. This step can drastically affect downstream analyses. 
Alignments can be quality check using RSeQC, QoRTs, etc. 

# Read Count
Cool, we are done with alignment. We will now move to counting those alignments in a meaningful way. 
Few tools for counting reads are [featurecounts]() and [HTSeq Count]....

I'm using here featureCounts

`bash scripts/pl_counts.sh [options]`

# Differential gene expression analysis 
Now we have the read count matrix. With this we can perform various downstream analyses such as Differential gene expression analysis, etc.

Using R packages
