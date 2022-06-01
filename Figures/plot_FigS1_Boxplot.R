library(ggplot2)
library(dplyr)
library(data.table)

Input_file = "Merged_MAF.txt"
dat = fread(Input_file,header=F,sep="\t")
Samples = filter(dat,V27 == "Liang et al. (2017)") %>%
  group_by(V26) %>%
  summarise(Median = median(V14))
  
Liang = filter(dat,V27 == "Liang et al. (2017)")
Liang$V26 = factor(Liang$V26,levels=Samples$V26[order(Samples$Median)])

pdf(file="Liang_boxplot.pdf",width=8/2.54,height=3.8/2.54)
ggplot(Liang,aes(V26,V14))+geom_boxplot(outlier.size = 0.5)+
  ggtitle("Liang et al. (2017)")+
  ylab("MAF")+
  theme_bw()+
  theme(
    plot.title = element_text(size=unit(8,"pt"),hjust=0.5),
    axis.title = element_text(size=unit(7,"pt")),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.text=element_text(size=6),
    axis.ticks.x  = element_blank()
  )
dev.off()

Samples = filter(dat,V27 == "Van Allen et al (2015)") %>%
  group_by(V26) %>%
  summarise(Median = median(V14))

Liang = filter(dat,V27 == "Van Allen et al (2015)")
Liang$V26 = factor(Liang$V26,levels=Samples$V26[order(Samples$Median)])

pdf(file="Van_boxplot.pdf",width=4.5/2.54,height=3.8/2.54)
ggplot(Liang,aes(V26,V14))+geom_boxplot(outlier.size = 0.5)+
  ggtitle("Van Allen et al. (2015)")+
  ylab("MAF")+
  theme_bw()+
  theme(
    plot.title = element_text(size=unit(8,"pt"),hjust=0.5),
    axis.title = element_text(size=unit(7,"pt")),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.text=element_text(size=6),
    axis.ticks.x  = element_blank()
  )
dev.off()

Samples = filter(dat,V27 == "David et al (2019)") %>%
  group_by(V26) %>%
  summarise(Median = median(V14))

Liang = filter(dat,V27 == "David et al (2019)")
Liang$V26 = factor(Liang$V26,levels=Samples$V26[order(Samples$Median)])

pdf(file="David_boxplot.pdf",width=5.5/2.54,height=3.8/2.54)
ggplot(Liang,aes(V26,V14))+geom_boxplot(outlier.size = 0.5)+
  ggtitle("David et al. (2019)")+
  ylab("MAF")+
  theme_bw()+
  theme(
    plot.title = element_text(size=unit(8,"pt"),hjust=0.5),
    axis.title = element_text(size=unit(7,"pt")),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.text=element_text(size=6),
    axis.ticks.x  = element_blank()
  )
dev.off()

Samples = filter(dat,V27 == "Ferney et al. (2013)") %>%
  group_by(V26) %>%
  summarise(Median = median(V14))

Liang = filter(dat,V27 == "Ferney et al. (2013)")
Liang$V26 = factor(Liang$V26,levels=Samples$V26[order(Samples$Median)])

pdf(file="Ferney_boxplot.pdf",width=3.8/2.54,height=3.8/2.54)
ggplot(Liang,aes(V26,V14))+geom_boxplot(outlier.size = 0.5)+
  ggtitle("Furney et al. (2013)")+
  ylab("MAF")+
  theme_bw()+
  theme(
    plot.title = element_text(size=unit(8,"pt"),hjust=0.5),
    axis.title = element_text(size=unit(7,"pt")),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.text=element_text(size=6),
    axis.ticks.x  = element_blank()
  )
dev.off()

Samples = filter(dat,V27 == "Newell et al. (2019)") %>%
  group_by(V26) %>%
  summarise(Median = median(V14))

Liang = filter(dat,V27 == "Newell et al. (2019)")
Liang$V26 = factor(Liang$V26,levels=Samples$V26[order(Samples$Median)])

pdf(file="Newell2019_boxplot.pdf",width=14/2.54,height=3.8/2.54)
ggplot(Liang,aes(V26,V14))+geom_boxplot(outlier.size = 0.5)+
  ggtitle("Newell et al. (2019)")+
  ylab("MAF")+
  theme_bw()+
  theme(
    plot.title = element_text(size=unit(8,"pt"),hjust=0.5),
    axis.title = element_text(size=unit(7,"pt")),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.text=element_text(size=6),
    axis.ticks.x  = element_blank()
  )
dev.off()

Samples = filter(dat,V27 == "Newell et al. (2020)") %>%
  group_by(V26) %>%
  summarise(Median = median(V14))

Liang = filter(dat,V27 == "Newell et al. (2020)")
Liang$V26 = factor(Liang$V26,levels=Samples$V26[order(Samples$Median)])

pdf(file="Newell2020_boxplot.pdf",width=16/2.54,height=3.8/2.54)
ggplot(Liang,aes(V26,V14))+geom_boxplot(outlier.size = 0.5)+
  ggtitle("Newell et al. (2020)")+
  ylab("MAF")+
  theme_bw()+
  theme(
    plot.title = element_text(size=unit(8,"pt"),hjust=0.5),
    axis.title = element_text(size=unit(7,"pt")),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.text=element_text(size=6),
    axis.ticks.x  = element_blank()
  )
dev.off()