#!/bin/bash

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


module load codes/star-2.7

if [[ -z "$sample_names_list" ]]; then 
### storing file name prefixes
    ls $raw_data/*${frwdsuffix} | xargs -n 1 basename | sed s/${frwdsuffix}// | sort -u > $inputdir/sample_names_list
fi

echo $sample_names_list

while read i; do
STAR --genomeDir $indexdir --runThreadN 60 \
--readFilesIn $inputdir/${i}${frwdsuffix} $inputdir/${i}${revsuffix} \
--outSAMtype BAM SortedByCoordinate \
--outBAMsortingThreadN 50 \
--outSAMunmapped SAM unmappedReads \
--readFilesCommand zcat \
--outFilterMultimapNmax 20 \
--outSAMunmapped Within \
--outSAMattributes NH HI AS NM MD \
--outFilterType BySJout \
--outFileNamePrefix $outdir/$i \
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
--sjdbScore 1 2> $outdir/${i}.stderr;
done < "$inputdir/sample_names_list"

echo 'completed'
