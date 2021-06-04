#!/bin/bash

 ## ======= comment out PBS parameters if not using HPC; for comment out use doube hash tag =======
 
#PBS -l nodes=node1:ppn=60
#PBS -N process
#PBS -o process.out
#PBS -e process.err

echo -e "\tAligning reads...."

echo $indexdir 
echo $inputdir
echo $outdir
echo $gtf
echo $sample_names_list 
echo $frwdsuffix
echo $revsuffix
echo $num_threads

module load codes/star-2.7

if [ -z "$sample_names_list" ]; then 
### storing file name prefixes
    ls $inputdir/*${frwdsuffix} | xargs -n 1 basename | sed s/${frwdsuffix}// | sort -u > $inputdir/sample_names_list
fi

mkdir -p $inputdir/STARresults
outdir=$inputdir/STARresults

echo $sample_names_list

while read infile; do
STAR --genomeDir $indexdir --runThreadN $num_threads \
--readFilesIn $inputdir/${infile}${frwdsuffix} $inputdir/${infile}${revsuffix} \
--outSAMtype BAM SortedByCoordinate \
--outBAMsortingThreadN $num_threads \
--readFilesCommand zcat \
--outFilterMultimapNmax 20 \
--outSAMunmapped Within \
--outSAMattributes NH HI AS NM MD \
--outFilterType BySJout \
--outFileNamePrefix $outdir/$infile \
--chimOutType Junctions \
--chimOutJunctionFormat 1 \
--chimSegmentMin 12 \
--quantMode TranscriptomeSAM GeneCounts \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNoverReadLmax 0.04 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outFilterMismatchNmax 999 \
--sjdbScore 1 2> $outdir/${infile}.stderr;
done < "$inputdir/$sample_names_list"

echo 'completed'
