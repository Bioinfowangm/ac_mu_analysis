#Code for Figure S10, case A_WL_26 was shown as an example

library(ggplot2)
library(ggtext)
library(dplyr)
library(reshape2)
library(gridExtra)
library(ggpubr)

Input_A26_cnr = "26_145604_tumorDNA_WXS_preprocessed.cnr"
Input_A26_cns = "26_145604_tumorDNA_WXS_preprocessed.cns"
Input_A26_baf = "26_145604_tumorDNA_WXS_facets.snp.txt"
A26_cnr = read.table(Input_A26_cnr,header=T)
A26_cns = read.table(Input_A26_cns,header=T)
A26_cnr$col = ifelse(A26_cnr$start>=29421919 & A26_cnr$end<=29704664,"red","gray")
A26_cnr$size = ifelse(A26_cnr$start>=29421919 & A26_cnr$end<=29704664,0.6,0.4)
P_A26_CN = ggplot(filter(A26_cnr,chromosome=="chr17" & col=="gray" & (1:nrow(A26_cnr))%%6 == 0),aes((start+end)/2/1000000,log2)) +
  geom_point(color="gray",size=0.03)+
  geom_point(data=filter(A26_cnr,chromosome=="chr17" & col=="red"),aes((start+end)/2/1000000,log2),color="red",size=0.5)+
  geom_segment(aes(x=start/1000000,xend=end/1000000,y=log2,yend=log2),color="darkorange1",lineend="round",size=1,data=filter(A26_cns,chromosome=="chr17"))+
  ylab("log<sub>2</sub>Ratio<br>(tumor/normal)")+  #annotate("text",x=52000000,y=6,label="Mel1",angle=270,size=3.5)+
  xlab("Chromosome 17 (MB)")+
  labs(title="A_WL_26")+
  #geom_segment(aes(x=start,xend=start,y=-3,yend=2),linetype="dashed",color="darkorchid1",size=0.35,data=filter(A26_cns,chromosome=="chr17"))+
  geom_hline(yintercept=-1.63,linetype="dashed",color="darkorchid1",size=0.35)+
  coord_cartesian(xlim=c(0,81195209)/1000000,expand = F,clip = 'on')+
  #annotate("text",x=52000000,y=-0.5,label="A26",angle=270,size=3.5)+
  scale_y_continuous(limits=c(-3,1),breaks=c(-2,-1,0,1,2),labels=c(-2,-1,0,1,2))+
  theme_bw()+
  theme(
    axis.title.y = element_markdown(size=unit(6.5,"pt"),margin=unit(c(0,0,0,0),"pt")),
    axis.text.y=element_text(size=6),
    axis.text.x = element_blank(),
    axis.title.x=element_blank(),
    axis.ticks.x = element_blank(),
    plot.title=element_text(size=7.5,margin=unit(c(0,0,2,0),"pt"),hjust=0.5),
    legend.position = "none",
    panel.grid = element_blank(),
    plot.margin=unit(c(4,4,0,5),"pt")
  )

##################
baf = read.table(Input_A26_baf,header=F)
baf = filter(baf, V1 == "chr17");baf2 = baf[,c(2,5,6)]
baf_long = melt(baf2,id.vars="V2")
P_A26_baf = ggplot(baf)+
  geom_point(aes(V2/1000000,V5),color="gray",size=0.05)+
  coord_cartesian(xlim=c(0,81195209)/1000000,expand = F,clip = 'on')+
  scale_y_continuous(limits=c(0,1),breaks=c(0,0.5,1),labels=c(0,0.5,1))+
  ylab("BAF")+xlab("chr17 (Mb)")+
  theme_bw()+
  theme(panel.grid = element_blank(),
        #axis.text.x = element_blank(),
        axis.text.x = element_text(size=unit(6,"pt"),margin=unit(c(0,0,0,0),"pt")),
        axis.text.y = element_text(size=unit(6,"pt")),
        axis.title = element_text(size=unit(6.5,"pt"),margin=unit(c(0,0,0,0),"pt")),
        #axis.title.y = element_text(size=unit(6,"pt"),margin=unit(c(0,-2,0,0),"pt")),
        plot.margin=unit(c(1,2,0,2),"pt")
  )

pdf(file="A26-chr17.pdf",width=8/2.54,height=3.8/2.54)
ggarrange(P_A26_CN,P_A26_baf,ncol=1,nrow=2,heights=c(1,1),align="v")
dev.off()

P_A26_CN = ggplot(filter(A26_cnr,chromosome=="chr17" & col=="gray" & (1:nrow(A26_cnr))%%6 == 0),aes((start+end)/2/1000000,log2)) +
  geom_point(color="gray",size=0.03)+
  geom_point(data=filter(A26_cnr,chromosome=="chr17" & col=="red"),aes((start+end)/2/1000000,log2),color="red",size=0.5)+
  geom_segment(aes(x=start/1000000,xend=end/1000000,y=log2,yend=log2),color="darkorange1",lineend="round",size=1,data=filter(A26_cns,chromosome=="chr17"))+
  ylab("log<sub>2</sub>Ratio<br>(tumor/normal)")+  #annotate("text",x=52000000,y=6,label="Mel1",angle=270,size=3.5)+
  xlab("Chromosome 17 (MB)")+
  labs(title="A_WL_26")+
  #geom_segment(aes(x=start,xend=start,y=-3,yend=2),linetype="dashed",color="darkorchid1",size=0.35,data=filter(A26_cns,chromosome=="chr17"))+
  geom_hline(yintercept=-1.63,linetype="dashed",color="darkorchid1",size=0.35)+
  coord_cartesian(xlim=c(29421919-1000000,29704664+1000000)/1000000,expand = F,clip = 'on')+
  #annotate("text",x=52000000,y=-0.5,label="A26",angle=270,size=3.5)+
  scale_y_continuous(limits=c(-3,1),breaks=c(-2,-1,0,1,2),labels=c(-2,-1,0,1,2))+
  theme_bw()+
  theme(
    axis.title.y = element_markdown(size=unit(6.5,"pt"),margin=unit(c(0,0,0,0),"pt")),
    axis.text.y=element_text(size=6),
    axis.text.x = element_blank(),
    axis.title.x=element_blank(),
    axis.ticks.x = element_blank(),
    plot.title=element_text(size=7.5,margin=unit(c(0,0,2,0),"pt"),hjust=0.5),
    legend.position = "none",
    panel.grid = element_blank(),
    plot.margin=unit(c(4,4,0,5),"pt")
  )

##################
P_A26_baf = ggplot(baf_long)+
  geom_point(aes(V2/1000000,value),color="gray",size=0.05)+
  coord_cartesian(xlim=c(29421919-1000000,29704664+1000000)/1000000,expand = F,clip = 'on')+
  scale_y_continuous(limits=c(0,1),breaks=c(0,0.5,1),labels=c(0,0.5,1))+
  ylab("BAF")+xlab("chr17 (Mb)")+
  theme_bw()+
  theme(panel.grid = element_blank(),
        #axis.text.x = element_blank(),
        axis.text.x = element_text(size=unit(6,"pt"),margin=unit(c(0,0,0,0),"pt")),
        axis.text.y = element_text(size=unit(6,"pt")),
        axis.title = element_text(size=unit(6.5,"pt"),margin=unit(c(0,0,0,0),"pt")),
        #axis.title.y = element_text(size=unit(6,"pt"),margin=unit(c(0,-2,0,0),"pt")),
        plot.margin=unit(c(1,2,0,2),"pt")
  )

pdf(file="A26-chr17-NF1.pdf",width=6/2.54,height=3.8/2.54)
ggarrange(P_A26_CN,P_A26_baf,ncol=1,nrow=2,heights=c(1,1),align="v")
dev.off()
