#!/bin/bash

input=$1  

cd $input
mkdir output_dir
out_dir=$1/output_dir

fastqc -t $2 $input/*.fastq.gz -o $out_dir

cd $out_dir

multiqc .

echo -e "process completed"

