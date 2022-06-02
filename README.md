# Integrated genomic analyses of acral and mucosal melanomas nominate novel driver genes
This repository includes codes for the meta-analysis of acral and mucosal melanomas. 

The **Pipeline_Scripts** folder contains scripts used for:
- Calling somatic mutations (_Mutect2_ and _Strelka2_), annotating (_ANNOVAR_) and filtering
- Calling germline mutations (_HaplotypeCaller_), annotating (_ANNOVAR_) and filtering
- Copy number analysis (_FACETS_, _CNVkit_ and _GISTIC2_)
- Calling structural alterations (_Delly_)
- Estimating degree of microsatellite instability (_MISsensor_)
- Survival analysis (R package _survival_ )

The **Figure_Scripts** folder includes R scripts used to plot figures in the manuscript.

The **Related_Files** folder includes some annotation files required by the pipeline.
