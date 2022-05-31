#Key variables(need to update for each patient)
Base_dir=" "  # output folder
Segmentation_fn=" " # file with segmentation data of all samples

gistic2 \
    -b $Base_dir \
    -seg $Segmentation_fn \
    -refgene ../Intervals/hg19.mat
