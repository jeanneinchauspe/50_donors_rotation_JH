module load bedtools/2.29.2


filename=$1
fn1=$(basename "$filename" .bed)
fn3=$fn1".metrics.txt"
fn4=$fn1".blacklist.bed"

bedtools intersect -v -a $fn2 -b /Filers/home/j/jinchaus/blacklists/hg38-blacklist.v2.bed.gz > $fn4



