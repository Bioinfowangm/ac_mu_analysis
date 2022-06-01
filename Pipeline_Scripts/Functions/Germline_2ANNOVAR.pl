#!/usr/bin/perl 
use strict;
use warnings;

my $Patient_Name = $ARGV[0];
open I_f,${Patient_Name}.g.SplitMulti.vcf;
open O_f, ">${Patient_Name}.g.SplitMulti.2ANNOVAR.vcf";
while(<I_f>){
    chomp;
    if(/^#/){
        print O_f "$_\n";
        next;
    }
    my @row = split;
    next if $row[4] eq '<NON_REF>';
    next if $row[4] eq '*';
    next if $row[-1] =~ /0\/0/;
    print O_f "$_\n";
}
