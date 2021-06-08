# load all packages required for the analysis

packages <- c("magrittr","DESeq2","ggplot2","pheatmap", "RColorBrewer", "dplyr")
invisible(lapply(packages, library, character.only = TRUE))

# set working directory

setwd("/Users/priyalakra/Desktop/RNAseq/Counts")

# load count matrix data and do some visualization 
readcounts <- read.table("fCounts.txt", header = TRUE)
dim(readcounts)
head(readcounts)

# remove columns that don't contain read counts
readcounts.new <- readcounts[ , -c(1)] # -c removes the columns specificed inside the paranthesis here 
dim(readcounts.new)
head(readcounts.new)

# change row names to geneids.And col names to sample  (that is already the case)
row.names(readcounts.new) <- readcounts$Geneid

names(readcounts.new) <- c("exp1","exp2","control1","control2") # using gsub here is a better option for larger number of columns


# create a metadata file
sample_info <- data.frame(condition=c("E","E","W","W"), row.names = names(readcounts.new))

# create a DESeq.ds object
DESeq.ds <- DESeqDataSetFromMatrix(countData = readcounts.new , colData = sample_info, design = ~ condition)
colData(DESeq.ds) %>% head # equivalent to head(colData(DESeq.ds)); here %>% works as (unix) pipe 
assay(DESeq.ds, "counts") %>% head
rowData(DESeq.ds) %>% head


# remove genes with 0 counts
DESeq.ds.new = DESeq.ds[ rowSums(counts(DESeq.ds)) > 0, ]
dim(DESeq.ds.new)

# checking; the below two codes should give same output as in the above step we removed genes with 0 counts!
a <- colSums(counts(DESeq.ds.new))
b <- colSums(readcounts.new)
a == b

# normalization by estimating size factors 
