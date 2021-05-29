#!/bin/bash

help(){
  echo "====== USAGE ======="
  echo -e "d (outdir)         Path to the star output results directory containing sam/bam files\n"
  echo -e "g (gtf)            Path to the gtf file and name\n"
  echo -e "t (num_threads)    Number of threads\n"
  echo -e "n (expName)        Name of the experiment to specify prefix of output\n"
  echo -e "s (strand)         Strandness of the RNA library. For foward, specify 1; for reverese, specify 2\n"
  echo -e "m (e)              Common suffix of input sam/bam files\n"
  echo -e "======== Be careful =========="
  echo -e "Specificy strand is very important for correct output\n"
  echo -e "It is good to use same annotation files for mapping and read counting\n"
  exit 1
}

while getopts "d:g:n:t:s:e:" opt; do
  case "opt" in
    d ) outdir="$OPTSARG" ;; 
    g ) gtf="$OPTSARG" ;; 
    n ) expName="$OPTSARG" ;;
    t ) num_threads="$OPTSARG" ;;
    s ) strand="$OPTSARG" ;;
    e ) suffix="$OPTSARG" ;;
    \?) help, exit 1
  esac
done
  
cd $outdir
mkdir featureCount_out

## ===== feature counts ===== 

featureCounts -F GTF -a $gtf -s $strand -T $num_threads -p $outdir/*${suffix} -o $outdir/featureCount_out/${expName}_counts 2> log.out

## ===== htseq counts =====




