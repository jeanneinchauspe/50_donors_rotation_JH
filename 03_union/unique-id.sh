#!/bin/bash

#SBATCH --partition=batch
#SBATCH --job-name=unique-id-bed
#SBATCH --mail-user=jeanne.inchauspe@dtc.ox.ac.uk
#SBATCH --mail-type=end,fail


#this script is making a unique id for each peak based on other columns in bed files
#also filters lanceotron peak score >= 0.5

for file in /t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/maxpeaks/Don*_ATAC_lanceotron_max_peaks.bed 

do


fn=$(basename "$file" _ATAC_lanceotron_max_peaks.bed)
echo $fn

awk '$4 >= 0.5' $file | awk -v myfn="$fn" 'BEGIN{OFS="\t"}{print $0 OFS myfn "-" $2 "-" $3}' - > $fn"_ATAC_lanceotron_max_peaks_with_ID.bed"


done


