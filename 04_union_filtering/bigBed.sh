#!/bin/bash

#SBATCH --partition=batch
#SBATCH --job-name=bedtoBigbed
#SBATCH --mail-user=jeanne.inchauspe@dtc.ox.ac.uk
#SBATCH --mail-type=end,fail


module load ucsctools
module load bedtools

for file in /t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/maxpeaks/Don*ATAC_lanceotron_max_peaks_with_ID.bed  

do


fn=$(basename "$file" .bed )
fn1=$fn".bb"
echo $fn1

awk -F '\t' '{print $1, $2, $3}' $file > shortfile.bed

sort -k1,1 -k2,2n shortfile.bed > sortedfile.bed

#bedToBigBed sortedfile.bed /home/j/jinchaus/genomes/hg19.genome $fn1 

bedToBigBed sortedfile.bed /databank/igenomes/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa.fai bigBed/$fn1

rm shortfile.bed
rm sortedfile.bed 



done
