#Key variables(need to update for each patient)
dbSNP="dbsnp_138.common.hg19.vcf" #from dbSNP
GERMLINE_BAM=" "     # bam file name of normal sample
TUMOR_BAM=" "        # bam file name of tumor sample
Patient_Name=" "     # name of the patient

snp-pileup -g -q15 -Q20 -P100 -r15,0 $dbSNP ${Patient_Name}_facets.csv.gz $GERMLINE_BAM $TUMOR_BAM

Rscript ./Functions/facets.R ${Patient_Name}
