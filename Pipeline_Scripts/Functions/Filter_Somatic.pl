#!/usr/bin/perl 
use strict;
use warnings;

my $Patient_Name = $ARGV[0];

my %artifact;
open I_f0,"${Patient_Name}_SOBDetector.txt";
while(<I_f0>){
    chomp;
    my @row = split /\t/,$_;
    my $id = join("\t",@row[0,1,2,3]);

    if(/Indel/){
        $artifact{$id} = 1;
        next;
    }   
    else{
        next if /artifact/;
        $artifact{$id} = 1;
    }   
}   

open I_f, "${Patient_Name}.annovar.hg19_multianno.txt";
open O_f, ">${Patient_Name}_filtered.annovar.txt";
Line: while (<I_f>) {
    chomp;
    if (/Func.refGene/) {
        print O_f "$_\n";
        next;
    }
    my @row = split /\t/, $_;
    next Line unless /PASS/;

    my $id = join("\t",@row[0,1,3,4]);
    next Line if $artifact{$id};

    my $label = "no";
    for my $af ( @row[ 10 .. 28 ] ) {
        $af = 0 if $af eq '.';
        next unless $af;
        next Line if $af > 0.01;
    }

    my @reads = split /,/, ( split /\|/, $row[-1] )[2];

    if ( /MT2:PASS/ && /SK:PASS/ ) {
        next
        if $reads[1] < 4;
        print O_f "$_\n";
        next;
    }
    if (/PASS/) {
        next unless $row[5] eq 'splicing' || $row[5] eq 'exonic';
        next unless ( $reads[2] + $reads[3] ) >= 10;
        next unless ( $reads[0] + $reads[1] ) >= 10;
        next if $reads[3] >2 || $reads[3]/($reads[2]+$reads[3])>0.03;
        next if ($reads[1]/($reads[0]+$reads[1])) < 0.1 || $reads[1] < 6;
        next if ($row[3] eq '-' || $row[4] eq '-') && /CLUSTER/;
        print O_f "$_\n";
    }
}
