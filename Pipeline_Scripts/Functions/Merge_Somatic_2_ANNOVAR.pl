#!/usr/bin/perl 
use strict;
use warnings;

my $Patient_Name = $ARGV[0];
&Process( $Patient_Name );

sub Process() {
    my ( $Patient_Name ) = @_;
    my ( %FB, %MT2, %UG, %SK, %loci );
    my ($nindex,$tindex,$normal_id);
    open I_f1,
      "${Patient_Name}.somatic_m2_filtered_SplitMulti.vcf";
    while (<I_f1>) {
        chomp;
        my @row = split;
        if (/normal_sample/){
            ($normal_id) = /normal_sample=(.*)/;
            print "$normal_id\n";
        }
        if (/CHROM/) {
            $nindex = -1 if $row[-1] eq $normal_id;
            $tindex = -2 if $row[-1] eq $normal_id;
            $nindex = -2 if $row[-2] eq $normal_id;
            $tindex = -1 if $row[-2] eq $normal_id;
            next;
        }
        next unless /^chr/;
        next if /^chrM/;
        next if $row[0] =~ /_/;
        my $id       = join( "\t", @row[ 0, 1, 3, 4 ] );
        my @tumor    = split /:/, $row[$tindex];
        my @normal   = split /:/, $row[$nindex];
        my @tumorAD  = split /,/, $tumor[1];
        my @normalAD = split /,/, $normal[1];
        my $label    = $row[6] eq 'PASS' ? "PASS" : "Filtered";
        if (   $row[6] eq 'clustered_events'
            || $row[6] eq 'clustered_events;haplotype' )
        {
            $label = "CLUSTER";
        }

        #print join("\t",$id,"MT2:$label:$normal[1],$tumor[1]"),"\n";
        $MT2{$id}  = "MT2:$label:$tumor[1],$normal[1]";
        $loci{$id} = 1;
    }

    open I_f2_1,
"zcat ${Patient_Name}_analysis_path/results/variants/somatic.snvs.vcf.gz|";
    while (<I_f2_1>) {
        chomp;
        my @row = split;
        next unless /^chr/;
        next if /^chrM/;
        next if $row[0] =~ /_/;
        my @tumor  = split /:/, $row[-1];
        my @normal = split /:/, $row[-2];
        my ( %htumor, %hnormal );
        $htumor{A}  = ( split /,/, $tumor[-4] )[0];
        $htumor{C}  = ( split /,/, $tumor[-3] )[0];
        $htumor{G}  = ( split /,/, $tumor[-2] )[0];
        $htumor{T}  = ( split /,/, $tumor[-1] )[0];
        $hnormal{A} = ( split /,/, $normal[-4] )[0];
        $hnormal{C} = ( split /,/, $normal[-3] )[0];
        $hnormal{G} = ( split /,/, $normal[-2] )[0];
        $hnormal{T} = ( split /,/, $normal[-1] )[0];
        my $label = $row[6] eq 'PASS' ? $row[6] : "Filtered";
        my $info  = "SK:$label:"
          . join( ",",
            $htumor{ $row[3] },
            $htumor{ $row[4] },
            $hnormal{ $row[3] },
            $hnormal{ $row[4] } );
        my $id = join( "\t", @row[ 0, 1, 3, 4 ] );
        $SK{$id}   = $info;
        $loci{$id} = 1;
    }

    open I_f2_2,
"zcat ${Patient_Name}_analysis_path/results/variants/somatic.indels.vcf.gz|";
    while (<I_f2_2>) {
        chomp;
        my @row = split;
        next unless /^chr/;
        next if /^chrM/;
        next if $row[0] =~ /_/;
        my @tumor  = split /:/, $row[-1];
        my @normal = split /:/, $row[-2];
        my $normal_ref = ( split /,/, $normal[2] )[0];
        my $normal_alt = ( split /,/, $normal[3] )[0];
        my $tumor_ref  = ( split /,/, $tumor[2] )[0];
        my $tumor_alt  = ( split /,/, $tumor[3] )[0];
        my $label = $row[6] eq 'PASS' ? $row[6] : "Filtered";
        my $info  = "SK:$label:"
          . join( ",", $tumor_ref, $tumor_alt, $normal_ref, $normal_alt );
        my $id = join( "\t", @row[ 0, 1, 3, 4 ] );
        $SK{$id}   = $info;
        $loci{$id} = 1;

    }

    open O_f, ">${Patient_Name}.input";
    for my $k ( keys %loci ) {
        my $mt2 = $MT2{$k} ? $MT2{$k} : "-";
        my $sk  = $SK{$k}  ? $SK{$k}  : "-";
        my $oa;
        if ( $mt2 ne '-' ) {
            my @info1 = split /:/, $mt2;
            $oa = $info1[-1];
        }
        elsif ( $sk ne '-' ) {
            my @info1 = split /:/, $sk;
            $oa = $info1[-1];
        }

        my @oa_info = split /,/, $oa;
        next if $oa_info[0] eq '.' || $oa_info[1] eq '.';
        next if $oa_info[0] + $oa_info[1] < 10;

        my $comment = "comments: $mt2|$sk|$oa";
        my @row     = split /\s/, $k;
        if ( length( $row[2] ) == 1 && length( $row[3] ) == 1 ) {
            print O_f join( "\t", @row[ 0, 1, 1, 2, 3 ], $comment ), "\n";
        }
        elsif ( length( $row[2] ) == 1 && length( $row[3] ) > 1 ) {
            my $ref   = "-";
            my $alt   = substr( $row[3], 1, length( $row[3] ) - 1 );
            my $start = $row[1];
            my $end   = $row[1];
            print O_f join( "\t", $row[0], $start, $end, $ref, $alt, $comment ),
              "\n";
        }
        elsif ( length( $row[2] ) > 1 && length( $row[3] ) == 1 ) {
            my $alt   = "-";
            my $ref   = substr( $row[2], 1, length( $row[2] ) - 1 );
            my $start = $row[1] + 1;
            my $end   = $row[1] + length( $row[2] ) - 1;
            print O_f join( "\t", $row[0], $start, $end, $ref, $alt, $comment ),
              "\n";
        }
        elsif ( length( $row[2] ) > 1 && length( $row[3] ) > 1 ) {
            my $start = $row[1];
            my $end   = $row[1] + length( $row[2] ) - 1;
            print O_f
              join( "\t", $row[0], $start, $end, @row[ 2, 3 ], $comment ),
              "\n";
        }
    }
}
