#Code for Figure 6B. Case A_MELA_0009 is shown as an example. 

library(circlize)
library(dplyr)
library(scales)

colcode = data.frame(state=c("HLAMP","AMP","GAIN","NEUT","HETD","HOMD"),
                     col=c("red","red","red3","blue","green4","green"))

Breakpoint1_file="A_MELA_0009_b1.bed" #File with breakpoint 1
Breakpoint2_file="A_MELA_0009_b2.bed" #File with breakpoint 2
CNV_bin_file="A_MELA_0009.cnr" #File with bin level log2 Ratio (from CNVkit)

bed1 = read.table(Breakpoint1_file)
colnames(bed1) = c("chr","start","end")
bed1$chr = as.character(bed1$chr)
bed2 = read.table(Breakpoint2_file)
colnames(bed2) = c("chr","start","end")
bed2$chr = as.character(bed2$chr)
linkcol = ifelse(bed1$chr != bed2$chr,"gray","chocolate1")

cnv = read.table(CNV_bin_file,header=T)
cnv$col = "gray"
cnv$Chr= as.character(cnv$chromosome)
cnv$x = cnv$start
cnv$y = cnv$log2
################################

index = (bed1$chr=='chr6' | bed1$chr=='chr11' ) & (bed2$chr=='chr6' | bed2$chr=='chr11')
bed1 = bed1[index,]
bed2 = bed2[index,]
index = (bed1$chr != bed2$chr)
bed1 = bed1[index,]
bed2 = bed2[index,]

cnv = filter(cnv,chromosome=="chr6"| chromosome=="chr11")
cnv$log2 = ifelse(cnv$log2< -2, -2,cnv$log2)
cnv = cnv[(1:as.integer(nrow(cnv)/4))*4,]

linkcol = ifelse(bed1$chr != bed2$chr,"gray","chocolate1")

pdf(file="circos_MELA_0009_chr6_chr11.pdf",width=4.9/2.54,height=4.9/2.54)
circos.par(start.degree=90,gap.degree=20)
circos.initializeWithIdeogram(chromosome.index = c("chr6","chr11"),plotType = NULL)
circos.genomicIdeogram(track.height = mm_h(1.5),track.margin=c(0,0))
circos.track(sectors=cnv$chromosome,x=cnv$x,y=cnv$log2,ylim=c(-2,5),track.height=0.3,
             bg.border=alpha("darkseagreen1",alpha=0.3), bg.col=alpha("darkseagreen1",alpha=0.3),panel.fun = function(x,y){
               circos.points(x,y,pch=20,col="mediumorchid1",cex=0.1)
               circos.yaxis(side="left",at=c(-2,4),labels=c(-2,4),labels.cex=0.4)
             })
circos.lines(sector.index="chr6",x=c(0,171055067),y=c(0,0),lty="dashed",col="black")
circos.lines(sector.index="chr11",x=c(0,134946516),y=c(0,0),lty="dashed",col="black")

circos.genomicLink(bed1[linkcol=="gray",], bed2[linkcol=="gray",],col="lightyellow3",lwd=0.8)
circos.genomicLink(bed1[linkcol=="chocolate1",], bed2[linkcol=="chocolate1",],col="chocolate1")
dev.off()

