# version = 0.9.6

#Key variables(need to update for each patient)
REFERENCE_GENOME="genome.fa"  # Genome Reference (hg19)
TUMOR_BAM_base=" "        # prefix of tumor bam sample(not including '.bam')
TUMOR_BAM=${TUMOR_BAM_base}.bam
Germline_vcf=" " # Germline mutations in tumor and normal samples, can be from freebayes or other sources
Purity=" "
Diploid_logR=" "
Target_Interval=" "
Gender="x/y" # 'x': female; 'y': male

#${*ALL_TUMOR_BAM*}: bam of all tumor samples
#${*ALL_FEMALE_GERMLINE_BAM}: bam of all germline female samples

cnvkit.py batch \
    ${*ALL_TUMOR_BAM*} \
    --normal ${*ALL_FEMALE_GERMLINE_BAM} \
    --targets $Target_Interval \
    --annotate ../Intervals/refFlat.txt \
    --fasta $REFERENCE_GENOME \
    --access ../Intervals/access-5k-mappable.hg19.bed \
    --output-reference my_reference.cnn \
    --output-dir results/ \
    --diagram --scatter

# Re-center
cnvkit.py call ${TUMOR_BAM_base}.cnr  --purity $Purity --center-at $Diploid_logR -m clonal -x $Gender -o ${TUMOR_BAM_base}.call.cnr
cnvkit.py call ${TUMOR_BAM_base}.cns  --purity $Purity --center-at $Diploid_logR -m clonal -x $Gender -v $Germline_vcf -o ${TUMOR_BAM_base}.call.cns
