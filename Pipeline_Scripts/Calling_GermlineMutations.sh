# Calling Germline mutations using HaplotypeCaller

#Key variables(need to update for each patient)
REFERENCE_GENOME="genome.fa"  # Genome Reference (hg19)
GERMLINE_BAM_base=" "     # prefix of normal sample(not including '.bam')
GERMLINE_BAM=${GERMLINE_BAM_base}.bam
TUMOR_BAM_base=" "        # prefix of tumor bam sample(not including '.bam')
TUMOR_BAM=${TUMOR_BAM_base}.bam
Patient_Name=" "     # name of the patient
Germline_Resource="af-only-gnomad.raw.sites.hg19.vcf.gz" #from BROAD website
Region_to_include=" " # file with regions to include (usually with centromere and telomere removed)

# a) Run HaplotypeCaller 
gatk HaplotypeCaller \
    -R $REFERENCE_GENOME \
    -L ../Related_Files/hg19_RefSeq_CDSunique_add10bp.bed \
    -I $GERMLINE_BAM \
    -O ${Patient_Name}.g.vcf.gz -ERC GVCF

# b) Split multi-allelic sites
gatk LeftAlignAndTrimVariants \
    -O ${Patient_Name}.g.SplitMulti.vcf \
    -R $REFERENCE_GENOME \
    -V ${Patient_Name}.g.vcf.gz \
    -no-trim true --split-multi-allelics true

# c) Prepare for ANNOVAR
perl ./Function/Germline_2ANNOVAR.pl ${Patient_Name}

# d) Annotate with ANNOVAR
table_annovar.pl \
    ${Patient_Name}.g.SplitMulti.2ANNOVAR.vcf \
    /bastianlab/data1/mwang13/Database/humandb/ --buildver hg19 --vcfinput --otherinfo --thread 5 --remove --operation g,f,f,f,f,f,f,f,f,f,f,f --protocol refGene,exac03,gnomad_exome,esp6500siv2_all,1000g2015aug_all,avsnp150,ucsf500normT,ucsf500normN,cosmic89,cbio2019jun,clinvar2019mar,ljb26_all \
    --outfile ${Patient_Name}.annovar;

# e) Filtering
perl ./Function/Filter_Germline.pl ${Patient_Name}.annovar.hg19_multianno.txt >${Patient_Name}.annovar.hg19_multianno.filtered.txt
