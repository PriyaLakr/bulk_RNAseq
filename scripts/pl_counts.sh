#!/bin/bash

## ===== feature counts =====

featureCounts -T $num_threads -p -s $strand -F GTF -a $gtf -o $raw_wd/featureCount/counts.txt $raw_wd/star_results/*Coord.out.bam


## ===== htseq counts =====




