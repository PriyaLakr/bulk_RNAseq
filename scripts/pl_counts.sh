#!/bin/bash

help(){
  echo -e "\n======== Usage ========\n"
  echo -e "d (outdir)         Path to the star output results directory containing sam/bam files\n"
  echo -e "g (gtf)            Path to the gtf file and name\n"
  echo -e "t (num_threads)    Number of threads\n"
  echo -e "n (expName)        Name of the experiment to specify prefix of output\n"
  echo -e "s (strand)         Strandness of the RNA library. For foward, specify 1; for reverese, specify 2\n"
  echo -e "e (suffix)         Common suffix of input sam/bam files\n"
  echo -e "======== Be careful ========\n"
  echo -e "Specificy strand is very important for correct output\n"
  echo -e "It is good to use same annotation files for mapping and read counting\n"
  exit 1
}

while getopts "d:g:n:t:s:e:" opt; do
  case "$opt" in
    d ) outdir="$OPTARG" ;; 
    g ) gtf="$OPTARG" ;; 
    n ) expName="$OPTARG" ;;
    t ) num_threads="$OPTARG" ;;
    s ) strand="$OPTARG" ;;
    e ) suffix="$OPTARG" ;;
    \?) help; exit 1 ;;
  esac
done
  
  ## note: change it specific parameters instead of all 
if [ -z "$@" ]; then
  help
fi


mkdir -p $outdir/${expName}_featureCount_out

## ===== feature counts ===== 

featureCounts -F GTF -a $gtf -s $strand -p ${outdir}/*${suffix} -o ${outdir}/${expName}_featureCount_out/${expName}_counts -T $num_threads 2> ${outdir}/${expName}_featureCount_out/log.out



## ===== htseq counts =====


