
BAM_FILE=$1
regions=$2
folder=$3


fn=$(basename "$BAM_FILE" _phased_possorted_bam.bam)

echo $fn

OUTPUT_FILE="$3/$fn.$3.octopus.vcf"

echo $OUTPUT_FILE

module load octopus

octopus -I $BAM_FILE --regions-file $regions -R /t1-data/databank/igenomes/Homo_sapiens/UCSC/hg38/Sequence/WholeGenomeFasta/genome.fa -o $OUTPUT_FILE
