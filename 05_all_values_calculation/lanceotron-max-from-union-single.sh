#this script is converting files from bw to bdg, then sorting the bdg, and then mapping it back to the peak call bedfile, itself sorted, while also adding a column of max coverage to the bedfile.

module load ucsctools/385
module load bedtools

bw=$1 
fn=$(basename "$bw" ATAC_d13_extended_reads.bw)
 

unionbed=$2

echo $bw
echo $unionbed

outfile="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/maxunion/"$fn"ATAC_lanceotron_values_union.bed"

bdgname="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/BigWig/ATAC/bdg/"$fn"ATAC_bedgraph.bdg"

bigWigToBedGraph $bw $bdgname

echo "Bedgraph saved in variable, now sorting and mapping"

sort $bdgname -k1,1 -k2,2n | bedtools map -a $unionbed -b stdin -c 4 -o max > $outfile




