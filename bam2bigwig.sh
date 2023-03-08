#!/usr/bin/env bash
set -e 

dirname=miri
source $(dirname $(dirname $(which mamba)))/etc/profile.d/conda.sh

# variables
input_directory=$1
mkdir -p temp_dir
cp $(ls ${input_directory}/*.bam) temp_dir
output_directory=$2
mkdir -p $output_directory
log_file=${output_directory}/log_file.txt
touch $log_file

#conda create --name bam2bigwig
conda activate bam2bigwig
echo "Begin conversion process" > $log_file
for file in $(ls temp_dir/*.bam); do
	filename="$(basename "$file" .bam)"
	echo "Currently processing: $filename" >> $log_file
	nice samtools index $file "${file%.*}.bai"
	nice bamCoverage -b $file -o ${output_directory}/$filename".bw" 2>> $log_file
	echo "$filename conversion complete" >> $log_file
done
rm -r temp_dir

echo "Miriam is done"
