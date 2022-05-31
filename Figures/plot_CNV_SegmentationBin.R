#Code for Figure 1C. Also used for Figure 1D and S11, with modification of file names and paths
# bin level log2 Ratio (.cnr) and segmented (.cns) files from CNVkit were used as input

library(ggplot2)

MELA0277_cnr = read.table("A_MELA_0277_T.cnr",header=T)
MELA0277_cns = read.table("A_MELA_0277_T.cns",header=T)
MELA0277_cnr$col = ifelse(grepl("PTPRJ",MELA0277_cnr$gene),"red","gray")
MELA0277_cnr$size = ifelse(grepl("PTPRJ",MELA0277_cnr$gene),0.6,0.4)

P_MELA0277 = ggplot(filter(MELA0277_cnr,chromosome=="chr11" & col=="gray" & (1:nrow(MELA0277_cnr))%%6 == 0),aes((start+end)/2/1000000,log2)) +
  geom_point(color="gray",size=0.03)+
  geom_segment(aes(x=start/1000000,xend=end/1000000,y=log2,yend=log2),color="darkorange1",lineend="round",size=1,data=filter(MELA0277_cns,chromosome=="chr11"))+
  geom_point(data=filter(MELA0277_cnr,chromosome=="chr11" & col=="red"),aes((start+end)/2/1000000,log2),color="red",size=0.5)+
  ylab("log<sub>2</sub>Ratio (tumor/normal)")+  #annotate("text",x=52000000,y=6,label="Mel1",angle=270,size=3.5)+
  xlab("Chromosome 11 (MB)")+
  labs(title="A_MELA_0277")+
  #geom_segment(aes(x=start,xend=start,y=-3,yend=2),linetype="dashed",color="darkorchid1",size=0.35,data=filter(MELA0277_cns,chromosome=="chr11"))+
  #geom_vline(xintercept=21994490,linetype="dashed",color="darkorchid1",size=0.35)+
  coord_cartesian(xlim=c(0 -2000000,134946516+2000000)/1000000,expand = F,clip = 'on')+
  #annotate("text",x=52000000,y=-0.5,label="MELA0277",angle=270,size=3.5)+
  scale_y_continuous(limits=c(-4.5,1),breaks=c(-4,-3,-2,-1,0,1),labels=c(-4,-3,-2,-1,0,1))+
  theme_bw()+
  theme(
    axis.title.y = element_markdown(size=unit(7,"pt"),margin=unit(c(0,0,0,0),"pt")),
    axis.text.y=element_text(size=6),
    axis.text.x = element_text(size=unit(6,"pt")),
    axis.title.x=element_text(size=7),
    plot.title=element_text(size=7.5,margin=unit(c(0,0,2,0),"pt"),hjust=0.5),
    legend.position = "none",
    panel.grid = element_blank(),
    plot.margin=unit(c(4,4,0,5),"pt")
  )


pdf(file="PTPRJ_deepdel.A_MELA_0277.pdf",width=6.5/2.54,height=3.5/2.54)
P_MELA0277
dev.off()