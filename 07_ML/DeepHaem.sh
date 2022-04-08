#!/bin/bash

module load tensorflow1-cpu/202010
module load bedtools

MODEL_PATH="/t1-data/project/fgenomics/sriva/database/models/deepHaem/model_deephaem_endpool_4k_data/model"

WHOLE_GENOME_FASTA="/t1-data/project/fgenomics/sriva/database/whole_genome_fasta/hg38.fa"

OUTPUT_DIR="/t1-data/project/fgenomics/jinchaus/rotation/DeepHeam_out/GoF"

OUTPUT_TAG="GoF"

INPUT_FILE="/t1-data/project/fgenomics/jinchaus/rotation/DeepHeam_out/Gof.vcf"

date

python /t1-data/project/fgenomics/sriva/tools/deepHaem/run_deploy_net.py --dlmodel deepHaemWindow \
	--batch_size 20 \
	--out_dir ${OUTPUT_DIR}/dh_${OUTPUT_TAG}_variants \
	--name_tag dh_${OUTPUT_TAG} \
	--do damage_and_scores \
	--input ${INPUT_FILE} \
	--model ${MODEL_PATH} \
	--genome ${WHOLE_GENOME_FASTA} \
	--bp_context 1000 \
	--rounddecimals 5 \
	--num_classes 4384 \
	--run_on cpu \
	--slize 'all'
         
echo "Finished GoF.vcf"
date
