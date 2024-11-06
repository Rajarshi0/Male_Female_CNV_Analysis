for bam in *recal.bam; do
  samtools coverage -r Y:2654900-2655200 "$bam" | awk -v bam="$bam" 'NR>1 {print $0"\t"bam}'
done > coverage_summary.txt

