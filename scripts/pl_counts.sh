#!/bin/bash

## ===== feature counts ===== 
## Annotation files should be same for mapping and read counting 

featureCounts -T $num_threads -p -s $strand -F GTF -a $gtf -o $raw_wd/featureCount/counts.txt $raw_wd/star_results/*Coord.out.bam


## ===== htseq counts =====




