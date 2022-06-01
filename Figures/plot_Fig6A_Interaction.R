#Code for Figure 6A. Also used for Figures 7C-7E and S13, with modifications

library(ggplot2)
library(dplyr)
library(gdata)

Input_file = "Merged_Interaction.xlsx"
dat = read.xls(Input_file,header=T,sheet=1)
dat$FDR = p.adjust(dat$P,method='fdr')
dat$col = ifelse(dat$FDR < 0.05, "red","gray");dat$col = factor(dat$col,levels=c("red","gray"))
write.table(dat,file="out.txt",row.names=F,col.names = T,sep="\t",quote=F)

pdf(file="Merged_Interaction.pdf",width=7/2.54,height=7/2.54)
ggplot(dat,aes(log2(or+0.01),-log10(FDR),color=col,size=col)) + geom_point()+
  xlim(-6.7,6.2)+#ylim(0,3.7)+
  xlab("Log2 Ratio of\nobserved to expected co-occurrence frequency") + 
  ylab("-Log10 (FDR)")+
  scale_size_manual(values=c(1.4,0.75))+ 
  scale_color_manual(values=c("red","gray"))+
  theme_bw()+
  theme(axis.title = element_text(size=unit(8,"pt")),
        axis.text = element_text(size=unit(6,"pt")),
        legend.position = "none"
  )
dev.off()
