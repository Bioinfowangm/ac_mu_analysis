library(dplyr)
library(ggplot2)

Input_file1 = "ALL_Melanoma_Matrix_t.txt"
dat = read.table(Input_file1,header=T,row.names = 1,sep="\t")
dat6 = filter(dat,Studies=="David et al. (2019)" | 
                Studies=="Furney et al. (2013)" | 
                Studies=="Liang et al. (2017)" | 
                Studies=="Newell et al. (2019)" | 
                Studies=="Newell et al. (2020)" |
                Studies=="Van Allen et al. (2015)"
                )

myPCA = prcomp(dat6[,-97],center=T,scale. = T)
myPCs = as.data.frame(myPCA$x[,1:2])
myPCs$Studies = dat6$Studies

pdf(file="PCA.pdf",width=7/2.54,height=7/2.54)
ggplot(myPCs,aes(PC1,PC2,color=Studies))+geom_point(size=0.9)+
  xlab("PC1 (59.7%)")+ylab("PC2 (11.0%)") + ggtitle(label="All genome regions included")+
  guides(color=guide_legend(override.aes = list(size=2)))+
  theme_bw()+
  theme(axis.title = element_text(size=unit(8,"pt")),
        plot.title = element_text(size=unit(9,"pt"),hjust=0.5),
        axis.text = element_text(size=unit(6,"pt")),
        legend.margin = margin(t=0,b=-10),
        legend.title=element_blank(),
        legend.position = c(0.24,0.22),
        legend.background=element_blank(),
        legend.text = element_text(size=unit(6,"pt")),
        legend.key.height =unit(7.5,"pt"),
        legend.key.width=unit(7,"pt")
  )
dev.off()

######PCA for exomes
Input_file2 = "ALL_Melanoma_exome_Matrix_t.txt"
dat = read.table(Input_file2,header=T,row.names = 1,sep="\t")
dat6 = filter(dat,Studies=="David et al. (2019)" | 
                Studies=="Furney et al. (2013)" | 
                Studies=="Liang et al. (2017)" | 
                Studies=="Newell et al. (2019)" | 
                Studies=="Newell et al. (2020)" |
                Studies=="Van Allen et al. (2015)"
)

myPCA = prcomp(dat6[,-97],center=T,scale. = T)
myPCs = as.data.frame(myPCA$x[,1:2])
myPCs$Studies = dat6$Studies

pdf(file="PCA_exome.pdf",width=7/2.54,height=7/2.54)
ggplot(myPCs,aes(PC1,PC2,color=Studies))+geom_point(size=0.9)+
  xlab("PC1 (24.6%)")+ylab("PC2 (10.6%)") +ggtitle(label="Only exonic regions included")+
  guides(color=guide_legend(override.aes = list(size=2)))+
  theme_bw()+
  theme(axis.title = element_text(size=unit(8,"pt")),
        axis.text = element_text(size=unit(6,"pt")),
        plot.title = element_text(size=unit(9,"pt"),hjust=0.5),
        legend.margin = margin(t=0,b=-10),
        legend.title=element_blank(),
        legend.position = c(0.75,0.88),
        legend.background=element_blank(),
        legend.text = element_text(size=unit(6,"pt")),
        legend.key.height =unit(7.5,"pt"),
        legend.key.width=unit(7,"pt")
  )
dev.off()