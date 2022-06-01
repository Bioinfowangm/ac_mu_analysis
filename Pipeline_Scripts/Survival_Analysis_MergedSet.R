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
for (i in Genes){
  SPRED1 = Alterations$newID[Alterations$d==i]
  subInfo = Info[,c("Metaanalysis_ID","Status_brief","Survival..months.")]
  subInfo$SPRED1 = ifelse(subInfo$Metaanalysis_ID %in% SPRED1,"Y","N")
  
  subInfo$Status_brief = ifelse(subInfo$Status_brief == 1,0,1)
  colnames(subInfo) = c("Metaanalysis_ID","status","time","SPRED1")
  subInfo$time = as.numeric(subInfo$time)
  subInfo$status = as.numeric(subInfo$status)

  sfit <- survfit(Surv(time, status)~SPRED1, data=subInfo)
  Pvalues = c(Pvalues,surv_pvalue(sfit)$pval)
}

datout = data.frame(Genes,Pvalues)
datout$FDR = p.adjust(datout$Pvalues,method='fdr')
write.table(datout,file="Survival_Merged_P.txt",row.names = F,col.names = T,sep="\t",quote=F)