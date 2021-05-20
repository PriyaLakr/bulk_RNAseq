#!/bin/bash

# usage: bash pl_trim.sh [infile path] [threads]

cd $input_dir
mkdir trim_out
trim=$input_dir/trim_out


while getopts "i:s:t:o:m:a:l:" opt
  do
    case "opt" in:
      i ) input_dir="$OPTARG" ;;
      s ) infile_suffix="$OPTARG" ;;
      t ) num_thread="$OPTARG" ;;
     # o ) output_dir="$OPTARG" ;;
      k ) keepBothReads="$OPTARG" ;;
      a ) adapter_file="$OPTARG" ;;
      l ) min_len="$OPTARG" ;;
      \? ) help, exit 1
     esac
   done
   
   
for infile in *${infile_suffix};
  do name=$(basename $infile ${infile_suffix}); trimmomatic PE -threads $num_thread ${name}${infile_suffix} ${name}${infile_suffix}  $trim/${name}_R1_trim.fastq.gz  $trim/${name}_R1_untrim.fastq.gz  $trim/${name}_R2_trim.fastq.gz  $trim/${name}_R2_untrim.fastq.gz ILLUMINACLIP:${adapter_file}:2:30:10:8:${keepBothReads} MINLEN:${min_len};
done

echo "Done!"
