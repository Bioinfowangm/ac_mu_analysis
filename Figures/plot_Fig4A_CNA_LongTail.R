library(ggplot2)
library(ggtext)
library(dplyr)
library(reshape2)
library(gridExtra)
library(ggpubr)
library(gdata)

Input_CNA = "merge_mutation_CNV.xlsx"
dat = read.xls(Input_CNA,header=T,sheet=3)

mysum = gene = c()
for (g in names(table(dat$Gene))){
  mysum = c(mysum,sum(dat[dat$Gene==g,]$Frequency))
  gene = c(gene,g)
  
  if(length(dat[dat$Gene==g & dat$SubType == "A","Frequency"])==0){
    dat = dat %>% add_row(Frequency=0,Gene=g,MutType=dat[dat$Gene==g & dat$SubType == "M","MutType"],SubType="A")
  }
  if(length(dat[dat$Gene==g & dat$SubType == "M","Frequency"])==0){
    dat = dat %>% add_row(Frequency=0,Gene=g,MutType=dat[dat$Gene==g & dat$SubType == "A","MutType"],SubType="M")
  }
}

Fre_dat = data.frame(gene,mysum)

dat$Gene = factor(dat$Gene,levels=Fre_dat$gene[order(Fre_dat$mysum,decreasing = T)])
dat$MutType = factor(dat$MutType,levels=c("deep_del","Amp"))

M_p = ggplot(filter(dat,SubType=="M"),aes(Gene,Frequency/93,fill=MutType,group=MutType))+
  geom_bar(stat="identity")+ ylab("Fraction of cases")+
  theme_bw()+ 
  scale_y_continuous(limits=c(0,0.4),labels=c(0,0.2,0.4),breaks=c(0,0.2,0.4),position="right")+
  scale_fill_manual(values=c("blue","red"))+
  theme(axis.title.x = element_blank(),
        #axis.title.y = element_text(size=unit(8,"pt")),
        axis.title.y = element_blank(),
        #axis.text.y = element_text(size=unit(6,"pt")),
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

A_p = ggplot(filter(dat,SubType=="A"),aes(as.numeric(Gene),Frequency/147,fill=MutType,group=MutType))+
  geom_bar(stat="identity")+ ylab("Fraction of cases")+
  scale_y_reverse(lim=c(0.4,0),labels=c(0,0.2,0.4),breaks=c(0,0.2,0.4),position="right")+
  scale_fill_manual(values=c("blue","red"))+
  scale_x_continuous(minor_breaks = seq(1,137,1),sec.axis=dup_axis(breaks=1:137),expand=c(0,0.15))+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        #axis.title.y = element_text(size=unit(8,"pt")),
        axis.title.y = element_blank(),
        #axis.text.y = element_text(size=unit(6,"pt")),
        axis.text.y = element_blank(),
        axis.ticks.x.bottom  = element_blank(),
        legend.position = "none",
        panel.grid.minor = element_line(size=0.4),
        panel.grid.major = element_line(size=0.4),
        plot.margin = unit(c(0,2,0,5),"pt"),
        axis.text.x = element_blank())

pdf(file="CNA.A_vs_M.pdf",width=16/2.54,height=5.5/2.54)
ggarrange(M_p,A_p,ncol=1,nrow=2,heights=c(1.3,1),align="v")
dev.off()
