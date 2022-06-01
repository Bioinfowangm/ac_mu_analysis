library(ggplot2)
library(ggtext)
library(dplyr)
library(reshape2)
library(gridExtra)
library(ggpubr)
library(gdata)

Input_file = "merge_mutation_CNV.xlsx"
merged = read.xls("Input_file",header=T,sheet=4)

Table = (table(merged$d,merged$a))
dat = data.frame(
  Acral = Table[,1],
  Mucosal = Table[,2]
); rownames(dat) = names(table(merged$d))

dat = filter(dat,(Acral+Mucosal)>9)

dat = read.xls("./Merge_Mutation_CNV_count.xlsx",header=T,sheet=2)

P = c()
for (i in 1:nrow(dat)){
  if(!grepl("TERT_mut",rownames(dat)[i])){
    matrix = c(dat[i,"Acral"],147-dat[i,"Acral"],dat[i,"Mucosal"],93-dat[i,"Mucosal"]);dim(matrix)=c(2,2)
    P = c(P,fisher.test(matrix)$p.value)
  }
  else{
    matrix = c(dat[i,"Acral"],93-dat[i,"Acral"],dat[i,"Mucosal"],74-dat[i,"Mucosal"]);dim(matrix)=c(2,2)
    P = c(P,fisher.test(matrix)$p.value)
  }
}
dat$P = P
dat$fdr = p.adjust(dat$P,method='fdr')

dat$A_Freq = dat$Acral / 147
dat$M_Freq = dat$Mucosal / 93
dat$col = ifelse(dat$fdr < 0.05, "red",
                 ifelse(dat$P < 0.05,"orange","gray"))
dat$col = factor(dat$col,levels=c("red","orange","gray"))
write.table(dat,file="Scatter.A_vs_M.txt",sep="\t",quote=F,row.names=T,col.names=T)

pdf(file="Scatter.A_vs_M.pdf",width=5.5/2.54,height=5.5/2.54)
ggplot(dat,aes(A_Freq+rnorm(35,0,0.001),M_Freq++rnorm(35,0,0.001),color=col,size=col))+geom_point()+
  geom_abline(slope=1,intercept=0,color="gray25")+
  scale_x_continuous(expand=c(0,0),limits=c(-0.03,0.4))+
  scale_y_continuous(expand=c(0,0),limits=c(-0.03,0.4))+
  xlab("Fraction (acral)") + ylab("Fraction (mucosal)")+
  scale_size_manual(values=c(1.8,1.4,0.7))+ 
  scale_color_manual(values=c("red","orange","gray"))+
  theme_bw()+
  theme(axis.title = element_text(size=unit(8,"pt")),
        axis.text = element_text(size=unit(6,"pt")),
        #legend.position = c(0.2,0.95),
        legend.position = 'none',
        legend.margin = margin(t=0,b=-10),
        legend.title=element_blank(),
        legend.background=element_blank(),
        legend.text = element_text(size=unit(6,"pt")),
        legend.key.height =unit(7,"pt"),
        legend.key.width=unit(7,"pt")
)
dev.off()


