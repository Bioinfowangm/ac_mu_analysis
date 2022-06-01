library(ggplot2)
library(ggtext)
library(dplyr)
library(reshape2)
library(gridExtra)
library(ggpubr)
library(gdata)

Input_mut = "for_plot_addgerm.txt"

dat = read.table(Input_mut,header=F)
dat = filter(dat,(V2+V3 + V5 + V6)>0)
total = dat$V2 + dat$V3 + dat$V5 +dat$V6
dat = dat[order(total,decreasing = T),]
colnames(dat) = c("gene","Acral_sig","Acral_hotspot","Acral_other","Mucosal_sig","Mucosal_hotspot","Mucosal_other")

dat_long = melt(dat)
dat_long$gene = factor(dat_long$gene,levels=dat$gene)
dat_long$subtype = ifelse(grepl("Acral",dat_long$variable),"Acral","Mucosal")
dat_long$signot = ifelse(grepl("sig",dat_long$variable),"Annotated pathogenic mutations",
                         ifelse(grepl("hotspot",dat_long$variable),"COSMIC recurrent nonsynonymous mutations","Other mutations"))
dat_long$signot = factor(dat_long$signot,levels=c("Other mutations","COSMIC recurrent nonsynonymous mutations","Annotated pathogenic mutations"))

M_p = ggplot(filter(dat_long,subtype!="Acral"),aes(gene,value/93,fill=signot,group=signot))+
  geom_bar(stat="identity")+ ylab("Fraction of cases")+
  scale_fill_manual(values=c("gray","coral","brown"))+
  scale_y_continuous(position="right",limits=c(0,0.27))+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        #axis.title.y = element_text(size=unit(8,"pt")),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=unit(4.2,"pt"),angle=90,vjust=0.5,margin=margin(1,0,0,0)),
        #legend.position = c(0.85,0.75),
        legend.position = "none",
        legend.margin = margin(t=0,b=-10),
        legend.title=element_blank(),
        legend.background=element_blank(),
        legend.text = element_text(size=unit(6,"pt")),
        legend.key.height =unit(7,"pt"),
        legend.key.width=unit(7,"pt"),
        panel.grid.minor = element_line(size=0.4),
        panel.grid.major = element_line(size=0.4),
        plot.margin = unit(c(2,2,3,5),"pt")
  )

A_p = ggplot(filter(dat_long,subtype!="Mucosal"),aes(as.numeric(gene),value/147,fill=signot,group=signot))+
  geom_bar(stat="identity")+ ylab("Fraction of cases")+
  scale_fill_manual(values=c("gray","coral","brown"))+
  scale_y_reverse(lim=c(0.27,0),labels=c(0,0.1,0.2),breaks=c(0,0.1,0.2),position="right")+
  #scale_y_continuous(position="right")+
  scale_x_continuous(minor_breaks = seq(1,105,1),sec.axis=dup_axis(breaks=1:105),expand=c(0,0.15))+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        #axis.title.y = element_text(size=unit(8,"pt")),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.x.bottom  = element_blank(),
        legend.position = "none",
        panel.grid.minor = element_line(size=0.4),
        panel.grid.major = element_line(size=0.4),
        plot.margin = unit(c(0,2,0,5),"pt"),
        axis.text.x = element_blank())

pdf(file="Mutation.A_vs_M.pdf",width=16/2.54,height=5.5/2.54)
ggarrange(M_p,A_p,ncol=1,nrow=2,heights=c(1.38,1),align="v")
dev.off()
