#!/bin/bash

mkdir XY_CNVS
# Directory containing your BAM files
bam_directory="."

output_directory=XY_CNVS
# Input file containing file names and genders
input_file="coverage_summary.txt"

# Loop through each line in the input file
while IFS= read -r line; do
    # Extract file name and gender from the line
    filename=$(echo "$line" | awk '{print $10}')
    value=$(echo "$line" | awk '{print $6}')
    gender="unknown"


    if [ -e "$bam_directory/$filename" ]; then
        # Determine gender based on the value (using awk for floating-point comparison)
        if awk -v val="$value" 'BEGIN {if (val >= 90) exit 0; else exit 1}'; then
            gender="male"
        else
            gender="female"
        fi

        # Rename the file based on the gender
        base_filename=$(basename "$filename" .recal.bam)
        mv "$filename" "${output_directory}/${base_filename}_${gender}.recal.bam"
	cp ${base_filename}.recal.bai "${output_directory}/${base_filename}_${gender}.recal.bai"
        echo "Renamed file: $filename -> ${base_filename}_${gender}.recal.bam"
    else
        echo "File not found: $filename"
    fi
done < "$input_file"
