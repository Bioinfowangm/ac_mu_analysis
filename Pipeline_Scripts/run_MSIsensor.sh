# v0.2
#Key variables(need to update for each patient)
REFERENCE_GENOME="genome.fa"  # Genome Reference (hg19)
GERMLINE_BAM_base=" "     # prefix of normal sample(not including '.bam')
GERMLINE_BAM=${GERMLINE_BAM_base}.bam
TUMOR_BAM_base=" "        # prefix of tumor bam sample(not including '.bam')
TUMOR_BAM=${TUMOR_BAM_base}.bam
Patient_Name=" "     # name of the patient

#Step1: Scan genome
msisensor scan $REFERENCE_GENOME -o hg19_msisensor.txt

#Step2: run for each patient
msisensor msi \
    -d hg19_msisensor.txt \
    -t $TUMOR_BAM \
    -n $GERMLINE_BAM \
    -e ../Related_Files/hg19_RefSeq_CDSunique_add10bp.bed \
    -o ${Patient_Name}.MSIsensor
