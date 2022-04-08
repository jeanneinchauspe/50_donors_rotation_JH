
module load deeptools/current

file=$1
fn1=$(basename "$file" .filtered.sorted.bam)

#fn2=$fn1".bw"
fn3=$fn1"_extended_reads.bw"

#bamCoverage -b $file -o $fn2 --outFileFormat bigwig --binSize 1 --normalizeUsing CPM -p 4 

bamCoverage -b $file -o $fn3 --outFileFormat bigwig --binSize 1 --extendReads --normalizeUsing CPM -p 4 

