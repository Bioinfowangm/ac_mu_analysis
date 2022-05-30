# Calling somatic mutations using Mutect2 and Strelka2

#Key variables(paths were mostly not considered)
$REFERENCE_GENOME # Genome Reference (hg19)
$GERMLINE_BAM     # bam file name of normal sample
$TUMOR_BAM        # bam file name of tumor sample
$Patient_Name     # name of the patient
$Germline_Resource # usually is af-only-gnomad.raw.sites.hg19.vcf.gz from BROAD website
$Region_to_include # file with regions to include (usually with centromere and telomere removed)

#Part1: Calling mutation using Mutect2

# Get Panel of normal (a-c, optional)
# a) For each germline bam file, run:
gatk Mutect2 \
    -R $REFERENCE_GENOME \
    -I $GERMLINE_BAM \
    -max-mnp-distance 0 \
    -O $GERMLINE.vcf.gz

# After done for all germline samples, write the name of each sample, and the path of $GERMLINE.vcf.gz to a file called cohort_ctl_map.txt

# b) Merge all germline vcfs into a database 
gatk  GenomicsDBImport \
    -R $REFERENCE_GENOME \
    -L $Region_to_include \
    --genomicsdb-workspace-path PoN_db \
    --sample-name-map cohort_ctl_map.txt \
    --reader-threads 20

# c) Create PON
gatk CreateSomaticPanelOfNormals \
    -R $REFERENCE_GENOME \
    --germline-resource $Germline_Resource \
    -V gendb://PoN_db -O PoN.vcf.gz

# Run Mutect2 for each pair (normal and tumor) of samples (d-f)
# d) Get the SM (sample name) tag from normal sample
gatk GetSampleName \
    -I $GERMLINE_BAM \
    -O ${GERMLINE_BAM}.SM.txt
readarray -t SM<${GERMLINE_BAM}.SM.txt
ctl_SM=${SM[0]}

# e) run Mutect2 and do built-in filtering
gatk  Mutect2 \
    -R $REFERENCE_GENOME \
    -L $Region_to_include \
    -I $GERMLINE_BAM \
    -I $TUMOR_BAM \
    -normal $ctl_SM \
    --germline-resource af-only-gnomad.raw.sites.hg19.vcf.gz \
    --af-of-alleles-not-in-resource 0.001 \
    --disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \
    --panel-of-normals PoN.vcf.gz \
    --f1r2-tar-gz ${Patient_Name}.f1r2.tar.gz \
    -O ${Patient_Name}.somatic_m2.vcf.gz \
    -bamout ${Patient_Name}.m2.bam

gatk LearnReadOrientationModel \
    -I ${Patient_Name}.f1r2.tar.gz \
    -O ${Patient_Name}.read-orientation-model.tar.gz

gatk FilterMutectCalls \
    -V ${Patient_Name}.somatic_m2.vcf.gz \
    -R $REFERENCE_GENOME \
    --ob-priors ${Patient_Name}.read-orientation-model.tar.gz \
    -O ${Patient_Name}.somatic_m2_filtered.vcf.gz

# f) Split multi-allelic sites
gatk LeftAlignAndTrimVariants \
    -O ${Patient_Name}.somatic_m2_filtered_SplitMulti.vcf \
    -R $REFERENCE_GENOME\
    -V ${Patient_Name}.somatic_m2_filtered.vcf.gz \
    -no-trim true --split-multi-allelics true

#Part2: Calling mutation using Strelka2
# g)
configureStrelkaSomaticWorkflow.py \
    --config=./configureStrelkaSomaticWorkflow.py.ini \
    --normalBam=$GERMLINE_BAM \
    --tumorBam=$TUMOR_BAM \
    --referenceFasta=$REFERENCE_GENOME \
    --runDir=${Patient_Name}_analysis_path 

cd ${Patient_Name}_analysis_path
./runWorkflow.py \
    -m local -j 6

#Part3: Merge outputs from Mutect2 and Strelka2, annotate and perform filtering
# h) Merge outputs
perl ./Other_Scripts/Merge_Somatic_2_ANNOVAR.pl $Patient_Name

# i) Annotate with ANNOVAR
table_annovar.pl \
    ${Patient_Name}.input \
    humandb --buildver hg19 --otherinfo --thread 2 --remove --operation g,f,f,f,f,f,f,f,f,f,f,f --protocol refGene,exac03,gnomad_exome,esp6500siv2_all,1000g2015aug_all,avsnp150,ucsf500normT,ucsf500normN,cosmic89,cbio2019jun,clinvar2019mar,ljb26_all \
    --outfile  ${Patient_Name}.annovar

# j) Filtering
perl ./Other_Scripts/Filter_Somatic.pl $Patient_Name
