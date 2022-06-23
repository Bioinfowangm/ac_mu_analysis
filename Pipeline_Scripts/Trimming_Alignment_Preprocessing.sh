# From Fastq to BAM (ready for mutation calling and other downstream steps)

#Key variables(need to update for each patient)
REFERENCE_GENOME="genome.fa"  # Genome Reference (hg19)
SAMP_base=" "                 # prefix of sample(either normal or tumor)
raw_FASTQ_dir=" "             # Directory of raw Fastq files
trimmed_FASTQ_dir=" "         # Directory of Fastq files with adaptor trimmed
SNP_dir=" "                   # Directory of SNP files
TMP_dir=" "                   # A TMP folder
BAIT_INTERVALS=" "            # BAIT_INTERVALS of exome
TARGET_INTERVALS=" "          # TARGET_INTERVALS of exome


# a) Run Fastqc
fastqc -t 2 -o ${raw_FASTQ_dir} \
    ${raw_FASTQ_dir}/${SAMP_base}_R1_001.fastq.gz ${raw_FASTQ_dir}/${SAMP_base}_R2_001.fastq.gz

# b) Run fastp
fastp -i ${raw_FASTQ_dir}/${SAMP_base}_R1_001.fastq.gz \
    -I ${raw_FASTQ_dir}/${SAMP_base}_R2_001.fastq.gz \
    -o ${trimmed_FASTQ_dir}/${SAMP_base}_fastp_R1.fastq.gz \
    -O ${trimmed_FASTQ_dir}/${SAMP_base}_fastp_R2.fastq.gz \
    --unpaired1 ${trimmed_FASTQ_dir}/${SAMP_base}_fastp_unpaired.fastq.gz \
    --unpaired2 ${trimmed_FASTQ_dir}/${SAMP_base}_fastp_unpaired.fastq.gz \
    -j ${trimmed_FASTQ_dir}/${SAMP_base}_fastp.json \
    -h ${trimmed_FASTQ_dir}/${SAMP_base}_fastp.html -c -w 5 

# c) Alignment 
bwa mem -t 5 ${REFERENCE_GENOME} \
    ${trimmed_FASTQ_dir}/${SAMP_base}_fastp_R1.fastq.gz ${trimmed_FASTQ_dir}/${SAMP_base}_fastp_R2.fastq.gz \
    -M -R "@RG\tID:${SAMP_base}\tPL:ILLUMINA\tPU:None\tLB:1\tSM:${SAMP_base}" | samtools sort -@ 1 - -o ${SAMP_base}.bam

# d) Mark duplicates
gatk MarkDuplicates -I ${SAMP_base}.bam -O ${SAMP_base}_dedup.bam \
    -M ${SAMP_base}.dup_metrics --CREATE_INDEX true --VALIDATION_STRINGENCY SILENT --REMOVE_DUPLICATES true --TMP_DIR ${TMP_dir}

# e) Check insert size
gatk CollectInsertSizeMetrics -I ${SAMP_base}_dedup.bam -O ${SAMP_base}_insert_size_metrics.txt \
    -H ${SAMP_base}_insert_size_histogram.pdf --VALIDATION_STRINGENCY SILENT

# f) Run BQSR
gatk BaseRecalibrator -I ${SAMP_base}_dedup.bam -R ${REFERENCE_GENOME} \
    --known-sites ${SNP_dir}/hapmap_3.3.hg19.sites.vcf \
    --known-sites ${SNP_dir}/1000G_phase1.indels.hg19.sites.vcf \
    --known-sites ${SNP_dir}/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
    -O ${SAMP_base}_BSQR.table

gatk ApplyBQSR -R ${REFERENCE_GENOME} -I ${SAMP_base}_dedup.bam \
    --bqsr-recal-file ${SAMP_base}_BSQR.table -O ${SAMP_base}_dedup_BSQR.bam

# g) Left alignment at indel site (GATK 3.6)
java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R ${REFERENCE_GENOME} \
    -known ${SNP_dir}/1000G_phase1.indels.hg19.sites.vcf \
    -known ${SNP_dir}/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
    -I ${SAMP_base}_dedup_BSQR.bam -o ${SAMP_base}_realignertargetcreator.intervals

java -Xmx30G -Djava.io.tmpdir=${TMP_dir} -jar GenomeAnalysisTK.jar -T IndelRealigner -R ${REFERENCE_GENOME} \
    -targetIntervals ${SAMP_base}_realignertargetcreator.intervals \
    -known ${SNP_dir}/1000G_phase1.indels.hg19.sites.vcf \
    -known ${SNP_dir}/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
    -I ${SAMP_base}_dedup_BSQR.bam -o ${SAMP_base}_preprocessed.bam
# The final BAM file is ${SAMP_base}_preprocessed.bam

# h) Collect depth metrics
gatk CollectHsMetrics -I ${SAMP_base}_preprocessed.bam -O ${SAMP_base}_Hs_Metrics.txt -R ${REFERENCE_GENOME} \
    BAIT_INTERVALS=${BAIT_INTERVALS} TARGET_INTERVALS=${TARGET_INTERVALS}
