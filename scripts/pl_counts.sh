#!/bin/bash

cd $outdir
mkdir featureCount_out

## ===== feature counts ===== 
## Annotation files should be same for mapping and read counting 

featureCounts -F GTF -a $gdir/$gtf -s $strand -T $num_threads -p $outdir/*${suffix} -o $outdir/featureCount_out/${expName}_counts 2> log.out

## Specificy strand is very important for correct output
## ===== htseq counts =====




