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

cnvkit.py coverage -p 4 $GERMLINE_BAM ../Related_Files/wgs_Target.bed -o ${GERMLINE_BAM_base}.targetcoverage.cnn
cnvkit.py coverage -p 4 $TUMOR_BAM ../Related_Files/wgs_Target.bed -o ${TUMOR_BAM_base}.targetcoverage.cnn

# Obtain reference from female patients:
cnvkit.py reference ${GERMLINE_BAM_base}.targetcoverage.cnn \
    --fasta $REFERENCE_GENOME \
    -o my_reference.cnn --no-edge

cnvkit.py fix ${TUMOR_BAM_base}.targetcoverage.cnn MT my_reference.cnn -o ${TUMOR_BAM_base}.cnr --no-edge
cnvkit.py segment ${TUMOR_BAM_base}.cnr -t 1e-09 --drop-low-coverage -o ${TUMOR_BAM_base}.cns

# Optionally, with --scatter and --diagram
cnvkit.py scatter ${TUMOR_BAM_base}.cnr -s ${TUMOR_BAM_base}.cns -o ${TUMOR_BAM_base}-scatter.pdf
cnvkit.py diagram ${TUMOR_BAM_base}.cnr -s ${TUMOR_BAM_base}.cns -o ${TUMOR_BAM_base}-diagram.pdf

# Re-center (optional)
cnvkit.py call ${TUMOR_BAM_base}.cnr  --purity $Purity --center-at $Diploid_logR -m clonal -x $Gender -o ${TUMOR_BAM_base}.call.cnr
cnvkit.py call ${TUMOR_BAM_base}.cns  --purity $Purity --center-at $Diploid_logR -m clonal -x $Gender -v $Germline_vcf -o ${TUMOR_BAM_base}.call.cns
