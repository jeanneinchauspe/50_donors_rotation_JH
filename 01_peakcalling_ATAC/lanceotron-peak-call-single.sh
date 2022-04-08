
module load tensorflow2-cpu


file=$1
fn=$(basename "$file" d13_extended_reads.bw)

fn1="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/"$fn"lanceotron_peaks"
fn2="/t1-data/project/fgenomics/jinchaus/rotation/50Donors/peakcall/ATAC/lanceotron/"$fn"lanceotron_peaksmerge"
fn3=$fn"lanceotron_allpeaks.bed"

#for ATAC
python3 /package/lanceotron/20210519/lanceotron_genome.py  -m wide_and_deep_fully_trained_v5_03_grid_candidate.h5 -f $fn1 -t 4 -w 400 -c 4 $file

cd $fn2

cat chr1.bed chr2.bed chr3.bed chr4.bed chr5.bed chr6.bed chr7.bed chr8.bed chr9.bed chr10.bed chr11.bed chr12.bed chr13.bed chr14.bed chr15.bed chr16.bed chr17.bed chr18.bed chr19.bed chr20.bed chr21.bed chr22.bed chrX.bed > $fn3


