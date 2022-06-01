#Code for Figure 2C

library(ggplot2)
library(dplyr)
library(reshape2)
library(gridExtra)
library(ggpubr)
library(tidyverse)

FER = read.table("./FER_segs.txt",header=T)
FER$Log2 = ifelse(FER$Log2< -3, -3,FER$Log2)
FER$Log2 = ifelse(FER$Log2 > 3, 3,FER$Log2)
FER_heatmap = ggplot(FER,aes(xmin = Start,xmax = End,ymin = Index - 0.5,ymax = Index+0.5))+
  scale_x_continuous(expand = c(0.01, 0),limits=c(1.068e8,1.095e8),breaks=c(1.07e8,1.09e8),labels=c("107","109"))+
  geom_rect(aes(fill=Log2,color=Log2))+
  geom_vline(xintercept=c(107964840,108638291),linetype="dashed",color="gray50")+
  scale_fill_gradient2(low="mediumblue",mid="white",high="red")+
  scale_color_gradient2(low="mediumblue",mid="white",high="red")+
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(0,1,-2,1),"pt"))


Genes = data.frame(genes=c("FBXL17","LINC01023","FER","LOC285638","PJA2","MAN2A1"),
                   start=c(107194733,108063525,108083597,108572835,108670422,109025066),
                   end=c(107717799,108063962,108532541,108662070,108745675,109205326),
                   color=c("a","a","b","a","a","a"),
                   fill=c("a",'b','a','b',"a","a"))

myrect = ggplot(Genes) + 
  geom_rect(aes(xmin=start,xmax=end,ymin=1-0.5,ymax=1+0.5,color=color,fill=fill))+
  ylab("x")+
  scale_color_manual(values=c(NA,"black"))+
  scale_fill_manual(values=c("forestgreen","forestgreen"))+
  scale_x_continuous(expand = c(0.01, 0),limits=c(1.068e8,1.095e8),breaks=c(1.07e8,1.09e8),labels=c("107","109"))+
  theme(axis.ticks.y = element_blank(),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=unit(6,"pt")),
        panel.grid = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(-2,1,0,1),"pt"))

pdf(file="FER_output.pdf",width=5.0/2.54,height=3/2.54)
ggarrange(FER_heatmap,myrect,ncol=1,nrow=2,heights=c(1,0.25),align="v")
dev.off()
