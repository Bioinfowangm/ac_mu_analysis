#!/usr/bin/perl 
#===========================================================================
#
#         FILE: filter.pl
#        USAGE: perl filter.pl  
#
#       AUTHOR: Wang Meng, mengwang55@gmail.com
#      VERSION: 1.0
#      CREATED: 07/06/2021 04:04:24 PM
#===========================================================================

use strict;
use warnings;

while(<>){
    chomp;
    my @row = split /\t/,$_;
    next unless $row[5] eq 'exonic' || $row[5] eq 'splicing';
    next if $row[8] eq 'synonymous SNV';

    my $label = "no";
    for my $af ( @row[ 10 .. 28 ] ) {
        $af = 0 if $af eq '.' || $af eq '';
        $label="yes" if $af>0.01;
    }
    next if $label eq "yes";

    my @info = split /:/,$row[-1];
    next if @info == 1;
    my @ad = split /,/, (split /:/,$row[-1])[1];
    next unless $ad[1] > 3;
    next unless ($ad[1])/($ad[0]+$ad[1]) > 0.25;

    print "$_\n";
}
