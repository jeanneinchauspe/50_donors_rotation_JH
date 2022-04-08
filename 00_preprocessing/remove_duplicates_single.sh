
module load picard-tools/2.3.0
module load bedtools/2.29.2
module load samtools/1.10


filename=$1
fn1=$(basename "$filename" .bam)

fn2=$fn1".filtered.sorted.bam"
fn3=$fn1".metrics.txt"
fn4=$fn1".blacklist.bam"

java -jar /Filers/package/picard-tools/2.3.0/lib/picard.jar MarkDuplicates I=$filename O=$fn2 M=$fn3 REMOVE_DUPLICATES=true 

samtools index $fn2 

#bedtools intersect -v -abam $fn2 -b /Filers/home/j/jinchaus/blacklists/hg38-blacklist.v2.bed.gz > $fn4

#samtools index $fn4 


