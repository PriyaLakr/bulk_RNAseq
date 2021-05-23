#!/bin/bash

#PBS -l nodes=node1:ppn=50
#PBS -N process
#PBS -o process.out
#PBS -e process.err

echo -e "\tGenerating STAR index...."

echo $maxlen
echo $genomedir
echo $fastadir
echo $fasta
echo $gtf

module load codes/star-2.7

overhang=${maxlen}-1

STAR --runMode genomeGenerate --runThreadN 50 --genomeDir $genomedir --genomeFastaFiles $fastadir/$fasta --sjdbGTFfile $fastadir/$gtf --sjdbOverhang $overhang > STARindex.log

module unload codes/star-2.7

echo "done"
