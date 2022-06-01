#Code for Figure 2A. Also used for Figure S8

library(ggplot2)
library(dplyr)
library(reshape2)
library(gridExtra)
library(ggpubr)

dat = read.table("./scores.gistic",header=T,sep="\t")
dat$color = ifelse(dat$X.log10.q.value.< 1,"gray","red")
dat$Position = (dat$Start + dat$End)/2
dat$Chromosome = paste0("chr",dat$Chromosome)

chrlen = read.table("../Data_Files/chrLength.txt",header=T)
chrlen$col = rep(c("white","black"),12)
dat$aPosition = chrlen[match(dat$Chromosome,chrlen$Chr),]$aStart + dat$Position -1

myplotdat = filter(chrlen,Chr!="chrY" & Chr!="chrX")
amp = filter(dat,Type=="Amp")

myAmp=ggplot(filter(amp,color=="gray"),aes(aPosition,G.score))+
  geom_vline(xintercept = myplotdat$midPoint,color="gray",linetype="dashed",size=0.5)+
  geom_segment(aes(x=aPosition,xend=aPosition,y=G.score,yend=0),color="gray",size=0.3)+
  geom_segment(data=filter(amp,color=="red"),aes(x=aPosition,xend=aPosition,y=G.score,yend=0),color="red",size=0.3)+
  ylab(" ")+
  scale_x_continuous(expand = c(0.01, 0))+  
  scale_y_continuous(limits=c(0,2.6))+
  theme_classic()+
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text.y = element_text(size=unit(6,"pt")),
        axis.title.y = element_text(size=unit(7,"pt")),
        legend.position = "none",
        axis.line.x = element_blank(),
        axis.ticks.x = element_blank()
        )
  
del = filter(dat,Type=="Del")

myDel=ggplot(filter(del,color=="gray"),aes(aPosition,G.score))+
  geom_vline(xintercept = myplotdat$midPoint,color="gray",linetype="dashed",size=0.5)+
  geom_segment(aes(x=aPosition,xend=aPosition,y=G.score,yend=0),color="gray",size=0.3)+
  geom_segment(data=filter(del,color=="red"),aes(x=aPosition,xend=aPosition,y=G.score,yend=0),color="blue",size=0.3)+
  ylab(" ")+
  scale_x_continuous(expand = c(0.01, 0))+  
  scale_y_reverse(limits=c(1.2,0),breaks=c(1,0),labels=c(1,0))+
  theme_classic()+
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text.y = element_text(size=unit(6,"pt")),
        axis.title.y = element_text(size=unit(7,"pt")),
        legend.position = "none",
        axis.line.x = element_blank(),
        axis.ticks.x = element_blank()
  )

myrect = ggplot(myplotdat) + 
  geom_rect(aes(xmin=aStart,xmax=aEnd,ymin=1-0.5,ymax=1+0.5,fill=col))+
  scale_fill_manual(values=c("black","gray70"))+
  scale_x_continuous(expand = c(0.01, 0))+
  annotate("text",(myplotdat$aStart+myplotdat$aEnd)/2,y=c(rep(1,19),1.25,0.75,1.25),label=c(1:22),color="white",size=2)+
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(-2,1,-2,1),"pt"))

pdf(file="GISTIC2_output.pdf",width=15.5/2.54,height=5.5/2.54)
ggarrange(myAmp,myrect,myDel,ncol=1,nrow=3,heights=c(1,0.12,0.6),align="v")
dev.off()