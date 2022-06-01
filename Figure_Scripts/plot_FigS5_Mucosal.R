library(ggplot2)
library(gdata)
library(reshape2)
library(gridExtra)
library(ggpubr)
library(cowplot)

Input_file = "TMB_Signature.xlsx"
dat = read.xls(Input_file,sheet=1,header=T)
dat = dplyr::filter(dat,subtype=="M")
dat = dat[order(dat$TMB,decreasing=T),]
dat$Samples = factor(dat$Samples,levels=dat$Samples)

signatures = dat[,1:16]
signatures[,2:16] = signatures[,2:16]/rowSums(signatures[,2:16])
signatures_long = melt(signatures)
signatures_long$Samples = factor(signatures_long$Samples,levels=dat$Samples)

P_TMB = ggplot(dat,aes(Samples,TMB,fill=subtype)) + geom_bar(stat="identity")+
  ylab("Mutations per MB")+
  scale_fill_manual(labels=c(" "),values=c("black"))+
  guides(fill=guide_legend(override.aes = list(fill="white")))+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(size=8),
        axis.text.y = element_text(size=6),
        legend.position = "none",
  )

P_Signature = ggplot(signatures_long,aes(Samples,value,fill=variable))+geom_bar(stat="identity")+
  scale_fill_manual(values=c("gray85","darkslategray1","gray55","brown1","gray35","darkseagreen1","darkslateblue",
                             "hotpink1","darkorange","darkkhaki","deepskyblue","gold","gray1","mediumorchid1","burlywood4"))+
  ylab("SBS signatures")+
  guides(fill=guide_legend(ncol=2))+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(size=8),
        axis.text.y = element_text(size=6),
        #legend.position = "bottom",
        legend.margin = margin(t=-4,b=4,l=-8,r=-4),
        #legend.direction = "horizontal",
        legend.title=element_blank(),
        legend.background=element_blank(),
        legend.key.height =unit(8,"pt"),
        legend.key.width=unit(8,"pt"),
        legend.text = element_text(size=unit(6,"pt"),margin=margin(t=0,b=0,l=0,r=0)),
        plot.margin = margin(0,-5,0,0))

dat$otherDNV =  dat$CCTT -dat$DNV 
DNV = dat %>% dplyr::select(Samples,CCTT,otherDNV)
DNV_long = melt(DNV)
P_DNV0 = ggplot()+
  geom_bar(data=dplyr::filter(DNV_long,variable=="CCTT"),aes(Samples,value,fill=variable),stat="identity")+
  geom_bar(data=dplyr::filter(DNV_long,variable!="CCTT"),aes(Samples,value,fill=variable),stat="identity")+
  scale_fill_discrete(name=" ",labels=c("CC>TT","Others"))+
  scale_y_continuous(breaks=c(-400,-200,0,200),labels=c(400,200,0,200))+
  ylab("DNV frequency")+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(size=8),
        axis.text.y = element_text(size=6),
        #legend.position = c(0.85,0.85),
        legend.margin = margin(t=0,b=0),
        #legend.direction = "horizontal",
        legend.title=element_blank(),
        legend.background=element_blank(),
        legend.key.height =unit(8,"pt"),
        legend.key.width=unit(8,"pt"),
        legend.text = element_text(size=unit(6,"pt"),margin=margin(t=0,b=0,l=0,r=0)),
        #plot.margin = margin(0,0,0,0)
  )
P_pDNV0 = ggplot(data=dat)+
  geom_bar(aes(Samples,Prop_CCTT),stat="identity")+
  #ylim(-1000,1000)+
  ylab("CC>TT/DNV")+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(size=8),
        axis.text.y = element_text(size=6),
        plot.margin = margin(0,r=-20,l=2,0),
        #legend.position = c(0.85,0.85),
        legend.position = "none",
        #legend.direction = "horizontal",
        #plot.margin = margin(0,0,0,0)
  )

P_pMSI0 = ggplot(data=dat)+
  geom_bar(aes(Samples,MSIscore),stat="identity")+
  ylim(0,6)+
  ylab("MSI score")+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(size=8),
        axis.text.y = element_text(size=6),
        plot.margin = margin(0,r=-20,l=2,0),
        #legend.position = c(0.85,0.85),
        legend.position = "none",
        #legend.direction = "horizontal",
        #plot.margin = margin(0,0,0,0)
  )

legend_pTMB <- get_legend(
  P_TMB
)
legend_pSignature <- get_legend(
  P_Signature
)

legend_pDNV0 <- get_legend(
  P_DNV0
)
pdf(file="TMB_Signature_M.pdf",width=20/2.54,height=12/2.54)
plot_grid(P_TMB,legend_pTMB,
          P_Signature + theme(legend.position="none"),legend_pSignature,
          P_pDNV0,legend_pTMB,
          P_DNV0+ theme(legend.position="none"),legend_pDNV0,
          P_pMSI0,legend_pTMB,
          nrow=5,
          axis="tblr",align="hv",rel_widths = c(1,0.15),greedy=T,hjust=0)
dev.off()
