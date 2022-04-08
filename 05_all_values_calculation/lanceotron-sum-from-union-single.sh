module load ucsctools/385
module load bedtools

bdg=$1 
fn=$(basename "$bdg" _sbabedgraph.bdg)
 

unionbed=$2
window=$(basename "$unionbed" _filtered_T60_L150_M30.bed)

echo $bdg
echo $unionbed

outfile="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/H3K27ac/sumunion/"$fn"H3K27ac_lanceotron_values_"$window".bed"


#sort $bdg -k1,1 -k2,2n | bedtools map -a $unionbed -b stdin -c 4 -o max > $outfile
sort $bdg -k1,1 -k2,2n | bedtools map -a $unionbed -b stdin -c 4 -o sum > $outfile




