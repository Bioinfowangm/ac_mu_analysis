library(ggplot2)
library(gdata)
library(dplyr)

Input_file = "Additionalfile1_TableS1.xlsx"
dat = read.xls(Input_file,sheet=1,header=T)
dat = filter(dat,Note.Included_for_analysis..=="Yes")

#Acral, TMB
Acral = filter(dat,Primary_Site_Classification=="subungual" | Primary_Site_Classification=="sole")
wilcox.test(Acral$TMB ~ Acral$Primary_Site_Classification) # 1.974e-05
pdf(file="TMB_acral.pdf",width=3.8/2.54,height=4/2.54)
ggplot(Acral,aes(Primary_Site_Classification,TMB))+#geom_boxplot(outlier.shape = NA)+
  geom_jitter(alpha=0.6, width=0.15,size=0.3)+
  geom_segment(aes(x=0.75,xend=1.25,y=1.6,yend=1.6),color="lightblue3")+
  geom_segment(aes(x=1.75,xend=2.25,y=2.48,yend=2.48),color="lightblue3")+
  annotate("text",x=1.5,y=35,label="italic(P) == 1.97e-05",size=2.5,parse=T)+
  scale_x_discrete(labels=c("Sole","Subungual"))+
  theme_bw()+
  theme(
    axis.title = element_text(size=7),
    axis.text = element_text(size=5.5),
    axis.title.x = element_blank()
  )
dev.off()

#Acral, SBS7
wilcox.test(Acral$SBS7 ~ Acral$Primary_Site_Classification) # 0.012
pdf(file="SBS7_acral.pdf",width=3.8/2.54,height=4/2.54)
ggplot(Acral,aes(Primary_Site_Classification,SBS7))+#geom_boxplot(outlier.shape = NA)+
  geom_jitter(alpha=0.6, width=0.15,size=0.3)+
  geom_segment(aes(x=0.75,xend=1.25,y=0,yend=0),color="lightblue3")+
  geom_segment(aes(x=1.75,xend=2.25,y=0.16,yend=0.16),color="lightblue3")+
  annotate("text",x=1.5,y=1.04,label="italic(P) == 0.012",size=2.5,parse=T)+
  scale_x_discrete(labels=c("Sole","Subungual"))+
  theme_bw()+
  theme(
    axis.title = element_text(size=7),
    axis.text = element_text(size=5.5),
    axis.title.x = element_blank()
  )
dev.off()

#Mucosal, TMB
Mucosal = filter(dat,Primary_Site_Classification=="sinonasal_oropharyngeal" 
             | Primary_Site_Classification=="gastrointestinal"
             | Primary_Site_Classification=="Genitourinary")
wilcox.test(Mucosal$TMB ~ Mucosal$Primary_Site_Classification) # 
wilcox.test(Mucosal$TMB[Mucosal$Primary_Site_Classification=="sinonasal_oropharyngeal"],Mucosal$TMB[Mucosal$Primary_Site_Classification=="gastrointestinal"])
wilcox.test(Mucosal$TMB[Mucosal$Primary_Site_Classification=="sinonasal_oropharyngeal"],Mucosal$TMB[Mucosal$Primary_Site_Classification=="Genitourinary"])
wilcox.test(Mucosal$TMB[Mucosal$Primary_Site_Classification=="gastrointestinal"],Mucosal$TMB[Mucosal$Primary_Site_Classification=="Genitourinary"])

pdf(file="TMB_mucosal.pdf",width=4.4/2.54,height=4.7/2.54)
ggplot(Mucosal,aes(Primary_Site_Classification,TMB))+#geom_boxplot(outlier.shape = NA)+
  geom_jitter(alpha=0.6, width=0.15,size=0.3)+
  ylim(0,30)+
  geom_segment(aes(x=0.75,xend=1.25,y=2.16,yend=2.16),color="lightblue3")+
  geom_segment(aes(x=1.75,xend=2.25,y=1.71,yend=1.71),color="lightblue3")+
  geom_segment(aes(x=2.75,xend=3.25,y=2.98,yend=2.98),color="lightblue3")+
  scale_x_discrete(labels=c("Gastrointestinal","Genitourinary","Sinonasal/oropharyngeal"))+
  theme_bw()+
  theme(
    axis.title = element_text(size=7),
    axis.text = element_text(size=5.5),
    axis.text.x = element_text(angle=30,hjust=1),
    axis.title.x = element_blank()
  )
dev.off()

#Mucosal, SBS7
wilcox.test(Mucosal$SBS7[Mucosal$Primary_Site_Classification=="sinonasal_oropharyngeal"],Mucosal$SBS7[Mucosal$Primary_Site_Classification=="gastrointestinal"])
wilcox.test(Mucosal$SBS7[Mucosal$Primary_Site_Classification=="sinonasal_oropharyngeal"],Mucosal$SBS7[Mucosal$Primary_Site_Classification=="Genitourinary"])
wilcox.test(Mucosal$SBS7[Mucosal$Primary_Site_Classification=="gastrointestinal"],Mucosal$SBS7[Mucosal$Primary_Site_Classification=="Genitourinary"])
summary(Mucosal$SBS7[Mucosal$Primary_Site_Classification=="sinonasal_oropharyngeal"])
summary(Mucosal$SBS7[Mucosal$Primary_Site_Classification=="gastrointestinal"])
summary(Mucosal$SBS7[Mucosal$Primary_Site_Classification=="Genitourinary"])

pdf(file="SBS7_mucosal.pdf",width=4.4/2.54,height=4.7/2.54)
ggplot(Mucosal,aes(Primary_Site_Classification,SBS7))+#geom_boxplot(outlier.shape = NA)+
  ylim(0,1)+
  geom_jitter(alpha=0.6, width=0.15,size=0.3)+
  geom_segment(aes(x=0.75,xend=1.25,y=0,yend=0),color="lightblue3")+
  geom_segment(aes(x=1.75,xend=2.25,y=0,yend=0),color="lightblue3")+
  geom_segment(aes(x=2.75,xend=3.25,y=0.097,yend=0.097),color="lightblue3")+
  scale_x_discrete(labels=c("Gastrointestinal","Genitourinary","Sinonasal/oropharyngeal"))+
  theme_bw()+
  theme(
    axis.title = element_text(size=7),
    axis.text = element_text(size=5.5),
    axis.text.x = element_text(angle=30,hjust=1),
    axis.title.x = element_blank()
  )
dev.off()
