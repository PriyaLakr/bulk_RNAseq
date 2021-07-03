#!/bin/bash

help(){
	echo "Just a help!"
	echo "Usage: bash pl_STARalign.sh -i /DATA/align -d /PATH/TO/HUMAN/GENOME/INDEX  -f R1.fastq.gz  -r R2.fastq.gz  -t 16 -g /PATH/TO/HUMAN/GENOME/GTF/gencode.v36.primary_assembly.annotation.gtf"
}


while getopts "i:f:d:r:t:l:g::h" opt; do
	case "$opt" in
		i) inputdir="$OPTARG" ;; 
		f) frwdsuffix="$OPTARG" ;; 
		d) indexdir="$OPTARG" ;; 
		r) revsuffix="$OPTARG" ;; 
		t) num_threads="$OPTARG" ;; 
		l) sample_names_list="$OPTARG" ;;
		g) gtf="$OPTARG" ;;
		h) help; exit 1 ;; 
	esac
done


get_data(){
	if [ -z "$sample_names_list" ]; then 
    	ls $inputdir/*${frwdsuffix} | xargs -n 1 basename | sed s/${frwdsuffix}// | sort -u > $inputdir/sample_names_list
	fi
}


align_reads(){
	while read infile; do
	STAR --genomeDir $indexdir --runThreadN $num_threads \
	--readFilesIn $inputdir/${infile}${frwdsuffix} $inputdir/${infile}${revsuffix} \
	--sjdbGTFfile $gtf \
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
	done < "$inputdir/sample_names_list"

	echo 'completed'
}


if [ "$inputdir" ]; then  # if [ "$@" ]; then -> this aint working; check
	start=$(date +"%s")
	echo -e "\tAligning reads...." | tee -a run.info
	mkdir -p $inputdir/STARresults && \
	outdir=$inputdir/STARresults && \
	get_data && align_reads
	end=$(date +"%s")
	echo "process completed in $(( ($end - $start)/60 )) minutes" | tee -a run.info
fi 
	
