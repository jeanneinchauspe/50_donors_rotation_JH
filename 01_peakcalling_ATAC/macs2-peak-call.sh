#!/bin/bash

#SBATCH --partition=batch
#SBATCH --job-name=macs2
#SBATCH --mail-user=jeanne.inchauspe@dtc.ox.ac.uk
#SBATCH --mail-type=end,fail
#SBATCH -n 4


module load python-cbrg


mkdir macs2


for file in /t1-data/project/fgenomics/jinchaus/rotation/50Donors/filtered/ATAC/*.blacklist.bam

do

fn=$(basename "$file" d13.blacklist.bam)
fn1=$fn"peaks"

#for ATAC
macs2 callpeak -t $file -f BAMPE -n $fn1 --g hs --outdir ./macs2 -B -q 0.05

# for Chi-seq
#macs2 callpeak -t $file -c $inputfile -f BAMPE -n $fn1 --g hs --outdir ./macs2 -B -q 0.05

done
