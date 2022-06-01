library(ggplot2)
library(dplyr)
library(plyr)

Input_file = "plink.eigenvec.txt"
dat = read.table(Input_file,sep="\t")

dat$V2 = factor(dat$V2,levels=c("European","Admix_American","South_Asian","East_Asian","African","Current_study"))
dat$V3 = factor(dat$V3,levels=c("Predicted_European","Predicted_Admix_American","Predicted_South_Asian","Predicted_East_Asian","Predicted_African","OneK"))

pdf(file="Populations_PCA.pdf",width=16.8/2.54,height=13.5/2.54)
ggplot(dat,aes(V5,V6,color=V2,shape=V3))+geom_point(size=0.8)+
  geom_point(data=filter(dat,V3!="OneK"),aes(V5,V6,shape=V3),size=1.2)+
  scale_color_manual(name="1000G populations",values=c("darkolivegreen2","bisque2","cornflowerblue","cyan","coral","black"))+
  scale_shape_manual(name="Patients included\nin the present study",values=c(3,17,15,4,18,20))+
  xlab("Principal component 1") + ylab("Principal component 2")+
  theme_bw()+
  theme(
    axis.title = element_text(size=7),
    axis.text = element_text(size=5.5),
    legend.title = element_text(size=6.5),
    legend.text = element_text(size=5.5),
    legend.key.size = unit(8,"pt"),
    #legend.position = c(0.41,-0.26),
    legend.background = element_blank(),
    legend.margin=margin(l=-2,r=0)
  )
dev.off()
