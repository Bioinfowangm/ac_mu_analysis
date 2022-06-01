#Code for Figure 2B

library(ggplot2)
library(dplyr)
library(reshape2)
library(gridExtra)
library(ggpubr)
library(gdata)

SKP2 = read.table("./SKP2_segs.txt",header=T)
SKP2$Log2 = ifelse(SKP2$Log2< -3, -3,SKP2$Log2)
SKP2$Log2 = ifelse(SKP2$Log2 > 3, 3,SKP2$Log2)
SKP2_heatmap = ggplot(SKP2,aes(xmin = Start,xmax = End,ymin = Index - 0.5,ymax = Index+0.5))+
  scale_y_continuous(breaks=1:28,labels=SKP2$Sample[!duplicated(SKP2$Sample)],expand = c(0,0.2))+
  scale_x_continuous(expand = c(0.01, 0),limits=c(31000000,41000000),breaks=c(3.25e7,3.4e7,3.55e7,3.7e7,3.85e7,4.0e7),labels=c(32.5,34,35.5,37,3.85,40))+
  geom_rect(aes(fill=Log2,color=Log2))+
  scale_fill_gradient2(low="mediumblue",mid="white",high="red")+
  scale_color_gradient2(low="mediumblue",mid="white",high="red")+
  theme(axis.ticks.y = element_blank(),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=unit(6,"pt")),
        panel.grid = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(0,0,0,0),"pt"))

Genes1 = data.frame(genes=c("LMBRD2","MIR580","NADK2","SLC1A3"),
                    start=c(36098508,36147993,36192690,36606456),
                    end=c(36151989,36148090,36242381,36688436))

myrect1 = ggplot(Genes1) + 
  geom_rect(aes(xmin=start,xmax=end,ymin=1-0.5,ymax=1+0.5),fill="forestgreen")+
  ylab("x")+
  scale_x_continuous(expand = c(0.01, 0),limits=c(31000000,41000000),breaks=c(3.55e7,3.70e7),labels=c(3.55,37))+
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(-6,1,4,1),"pt"))

Genes2 = data.frame(genes=c("UGT3A2","SKP2","RANBP3L"),
                    start=c(36035118,36152144,36247020),
                    end=c(36067023,36184142,36302011),
                    color=c("a","b","a"))
myrect2 = ggplot(Genes2) + 
  geom_rect(aes(xmin=start,xmax=end,ymin=1-0.5,ymax=1+0.5,color=color),fill="forestgreen")+
  ylab("x")+
  scale_color_manual(values=c(NA,"black"))+
  scale_x_continuous(expand = c(0.01, 0),limits=c(31000000,41000000),breaks=c(3.55e7,3.70e7),labels=c(3.55,37))+
  theme(axis.ticks.y = element_blank(),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size=unit(6,"pt")),
        panel.grid = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.position = "none",
        plot.margin=unit(c(-6,1,4,1),"pt"))

pdf(file="SKP2_ZoomOut.pdf",width=3.2/2.54,height=6.76/2.54)
SKP2_heatmap
dev.off()