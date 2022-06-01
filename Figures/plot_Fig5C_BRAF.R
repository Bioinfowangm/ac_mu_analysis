library(gdata)
library(dplyr)
library(ggplot2)

Input_file = "My_KeyMut_BRAF.xlsx"
dat = read.xls(Input_file,header=T)
mydat = data.frame(table(dat$Subtype,dat$Group));
mydat = data.frame(Var1=c("A","M","A","M"),Var2=c("Class1","Class1","Others","Others"),Freq=c(29,6,7,9))
mydat$Freq = mydat$Freq / rep(c(147,93),2)

pdf(file="BRAF.pdf",width=4.2/2.54,height=5/2.54)
ggplot(mydat,aes(Var1,Freq,fill=Var2)) + geom_bar(stat="identity",position = "dodge") +
  ylab("Fraction of samples")+
  scale_x_discrete(labels=c("Acral","Mucosal"))+
  scale_fill_manual(values=c("darkorchid1","deepskyblue"),labels=c("Class 1","Others"))+
  ylim(0,0.22)+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        axis.title.y = element_text(size=unit(8,"pt")),
        axis.text.y = element_text(size=unit(6,"pt")),
        axis.text.x = element_text(size=unit(6,"pt")),
        legend.position = c(0.7,0.96),
        #legend.position = "none",
        legend.margin = margin(t=0,b=-10),
        legend.title=element_blank(),
        legend.background=element_blank(),
        legend.text = element_text(size=unit(6,"pt")),
        legend.key.height =unit(7,"pt"),
        legend.key.width=unit(7,"pt")
  )
dev.off()
