#!/bin/bash

#SBATCH --partition=batch
#SBATCH --job-name=union-lanceotron
#SBATCH --mail-user=jeanne.inchauspe@dtc.ox.ac.uk
#SBATCH --mail-type=end,fail
#SBATCH -n 8


#This script take the lanceotron peaks bed files with max peaks and merges them as a union. We explore three methods to do so. requirement: make unique ids with unique-id.sh before
 
module load bedtools bedops

#Option 1: bedtools merge
#concatenates all bed files with peaks values and id and sort, then pass to bedtools merge. This will be used in Option 3 Step 4 as well.

#cat Don*_ATAC_lanceotron_max_peaks_with_ID.bed > concat_ATAC_lanceotron_max_peaks_with_ID.bed

#sort -k1,1 -k2,2n concat_ATAC_lanceotron_max_peaks_with_ID.bed > concat_sorted_ATAC_lanceotron_max_peaks_with_ID.bed # sorting by chromosome and position

bedtools merge -i concat_sorted_ATAC_lanceotron_max_peaks_with_ID.bed -d -250 -c 19,20 -o collapse,collapse > bedtools_250bp_merge_union_ATAC_lanceotron_with_peaks_max.bed

#bedtools merge is told to make a two lists for each union peak: one with the identifier column of each peak, one with the max value of each peak.

#Option 2: bedops bedmap: we can specify how much overlap we want in a fraction. But we are loosing self overlapping peaks that do not overlap with anything else. Option 3 resolves that.

#But first, we are sorting individual bedfiles with the bedops sort-bed package, to then pass it to bedmap. This step is used in Option 3 as well.

#for file in /t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/maxpeaks/Don*_ATAC_lanceotron_max_peaks_with_ID.bed 
#
#do
#
#fn=$(basename "$file" _ATAC_lanceotron_max_peaks_with_ID.bed)
#echo $fn
#
#awk -F '\t' '{print $1, $2, $3, $20, $19}' $file | sort-bed - > $fn"_ATAC_lanceotron_max_peaks_with_ID_sorted.bed"
#
#done

#bedops --everything Don*_ATAC_lanceotron_max_peaks_with_ID_sorted.bed \
#| bedmap --echo  --count --range --mean --max --min --echo-map --fraction-both 0.7 --delim "\t" - \
#| awk '(split($0, a, ";") > 1)' - \
#| sed 's/\;/\n/g' - \
#| sort -k1,1 -k2,2n - \
#| uniq - > bedmaps_union_ATAC_lanceotron_with_peaks.bed


#Option 3: combine bedmaps and merge to get overlapping regions by 50 percent and self-overlapping regions. Caveat: we loose peaks that overlap less than 50% with any peak.

#Step 1: combine regions overlapping by 50%. Bedops is first concatenating the files, then overlapping mapping regions together, while generating a first column of sample counts within each union peak. Then we remove self-overlaping regions (count is 1), remove count column, make one line per peak, sort peaks and remove duplicate values (because each peak also overlaps to itself)
#
#bedops --everything Don*_ATAC_lanceotron_max_peaks_with_ID_sorted.bed \
#| bedmap --count --echo-map --fraction-both 0.5 --delim "\t" - \
#| awk '$1>1' - \
#| cut -f2- - \
#| sed 's/\;/\n/g' - \
#| sort-bed - \
#| uniq - \
#| awk '{sub (/ /, OFS)} 1' OFS="\t" - > mutuallyOverlappingIntervals.bed

#Step 2: we merge the mutually overlapping intervals using bedtools merge to be able to concatenate in a single line peaks IDs and values for overlapping regions.

#bedtools merge -i mutuallyOverlappingIntervals.bed -c 4,5 -o collapse,collapse > merged_mutuallyOverlappingIntervals.bed
#head mergedIntervals.bed

#Step 3: In preparation for step 4, we merge all peaks from the the original files with peaks values and ids. This is basically the output of Option 1, but with no minimum bp overlap.
#This union serves as a reference of any peak overlapping with any peak or themselves. Then we will be able to extract peaks only self-overlapping. 

#bedtools merge -i concat_sorted_ATAC_lanceotron_max_peaks_with_ID.bed -c 19,20 -o collapse,collapse > merged_intervals.bed  

# Now, we map the concatenated peaks with the union merged file which contain all peaks (self overlapping or overlapping any peak). We only retain peaks that have exact start and end bp matches from the union, meaning, peaks present in the concatenation of all peaks and present in the union on their own, which indicates that they are overlapping to themselves only.
#
#bedops --everything Don*_ATAC_lanceotron_max_peaks_with_ID_sorted.bed \
#| bedmap --echo --exact --skip-unmapped - merged_intervals.bed \
#| awk '{sub (/ /, OFS)} 1' OFS="\t" - > exclusiveIntervals.bed 

#We concatenate the exclusively self-overlapping peaks file (which does contain some exact matches present in the mutually overlapping union, because of exact start site or exact end site which do not seem to be diregarded - observe that by changing the option --echo to --echo-map) with the merged mutually overlapping union.
#
#cat merged_mutuallyOverlappingIntervals.bed exclusiveIntervals.bed | sort -k1,1 -k2,2n - > bedmaps_final_Union_lanceOtron_with_max_peaks.bed

#Here, we have a union of peaks that overlap a certain range (for example 50%) and peaks that never overlap. We are not able to have peaks which overlap less than 50% but more than 50% at the moment. Otherwise, they would be enlarging the union of those peaks to encompass more peaks. Hopefully, most peaks will be spaced enough, or 50% still makes union intervals large enough that we will get some examples of adjacent peaks and can categorise them as such (with high max value variation?)

#
#rm merged_intervals.bed
#rm merged_mutuallyOverlappingIntervals.bed
#rm exclusiveIntervals.bed 
#rm mutuallyOverlappingIntervals.bed
#









