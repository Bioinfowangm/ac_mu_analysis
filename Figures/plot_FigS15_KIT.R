library(ggplot2)
library(gdata)
library(dplyr)
library(survival)
library(survminer)

Input_TableS1 = "Additionalfile1_TableS1.xlsx"
Input_Alteration = "merge_mutation_CNV.xlsx"
Input_ID = "Sample_IDs.xlsx"

Info = read.xls(Input_TableS1,sheet=1,header=T)
Info = filter(Info,Note.Included_for_analysis..=="Yes")
Info = filter(Info,Status_brief == 0 | Status_brief == 1)

Alterations = read.xls(Input_Alteration,header=T,sheet=4)
Alterations = filter(Alterations,z != 'focal_del')
ID = read.xls(Input_ID,header=F)
index = match(Alterations$x, ID$V4)
Alterations$newID = ID$V2[index]
index2 = match(Alterations$newID,Info$Metaanalysis_ID)
Alterations = Alterations[!is.na(index2),]

Alterations = Alterations[Alterations$d %in% names(table(Alterations$d)[table(Alterations$d) >= 10]),]

Genes = names(table(Alterations$d))
Pvalues = c()
i="KIT_mut"
KIT_mutation = Alterations$newID[Alterations$d==i]
subInfo = Info[,c("Metaanalysis_ID","Status_brief","Survival..months.")]
subInfo$KIT_mutation = ifelse(subInfo$Metaanalysis_ID %in% KIT_mutation,"Y","N")

subInfo$Status_brief = ifelse(subInfo$Status_brief == 1,0,1)
colnames(subInfo) = c("Metaanalysis_ID","status","time","KIT_mutation")
subInfo$time = as.numeric(subInfo$time)
subInfo$status = as.numeric(subInfo$status)

sfit <- survfit(Surv(time, status)~KIT_mutation, data=subInfo)
pdf(file="Survival_Merged_KITmut.pdf",width=6.5/2.54,height=6.5/2.54)
ggsurvplot(sfit,pval=F,conf.int=TRUE,
           font.x=7,font.y=7,font.tickslab=6,size=0.5,censor.size=2.5,
           legend="none")
dev.off()
