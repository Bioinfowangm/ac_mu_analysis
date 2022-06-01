#Key variables(need to update for each patient)
REFERENCE_GENOME="genome.fa"  # Genome Reference (hg19)
dbSNP="dbsnp_138.common.hg19.vcf" #from dbSNP
GERMLINE_BAM=" "     # bam file name of normal sample
TUMOR_BAM=" "        # bam file name of tumor sample
Patient_Name=" "     # name of the patient
Samp_List=" "        # sample name of normal and tumor samples (see Delly2 webpage)

delly call -g $REFERENCE_GENOME \
    -x ../Intervals/human.hg19.excl.tsv \
    -o ${Patient_Name}.bcf \
    $TUMOR_BAM $GERMLINE_BAM


delly filter -f somatic -o ${Patient_Name}.somatic.bcf -s $Samp_List ${Patient_Name}.bcf
