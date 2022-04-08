module load bcftools vcftools samtools

for file in *.octopus.vcf
do 
bgzip $file 

done

for file in *.octopus.vcf.gz
do 
tabix -p vcf $file
done

vcf-merge *.octopus.vcf.gz | bgzip -c > merged.GoF.octopus.vcf.gz
