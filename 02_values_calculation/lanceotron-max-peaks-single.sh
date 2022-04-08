#this script is converting files from bw to bdg, then sorting the bdg, and then mapping it back to the peak call bedfile, itself sorted, while also adding a column of max coverage to the bedfile.

module load ucsctools/385
module load bedtools

file=$1 
fn=$(basename "$file" ATAC_lanceotron_allpeaks.bed)

bw="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/BigWig/ATAC/"$fn"ATAC_d13_extended_reads.bw" 

 
echo $file
echo $bw

sortedfile="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/sorted-peaks/"$fn"ATAC_lanceotron_sorted_peaks.bed"

outfile="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/maxpeaks/"$fn"ATAC_lanceotron_max_peaks.bed"

sort $file -k1,1 -k2,2n > $sortedfile

bdgname=$fn"bedgraph.bdg"

bigWigToBedGraph $bw $bdgname

echo "Bedgraph saved in variable, now sorting and mapping"

sort $bdgname -k1,1 -k2,2n | bedtools map -a $sortedfile -b stdin -c 4 -o max > $outfile

rm $bdgname

