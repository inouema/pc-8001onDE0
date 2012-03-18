#! /usr/bin/perl
use strict;
use warnings;

# 8x8のフォントデータを8x16にリサイズします.

# ファイルの読み込み
my $filename = $ARGV[0]; #引数に読み込みたいファイルを指定.
open my $file,'<',$filename or die; #ファイル読みこみ
my $val;

#出力ファイルを用意
open my $outfile,'> cgrom8x16.txt' or die;


my $i=0;

# 8行読み込んだら 8行ゼロパディングします.
while ($val = <$file>) {

    print $outfile $val;
    
    if($i==7) {
        print $outfile "00000000\r\n";
        print $outfile "00000000\r\n";
        print $outfile "00000000\r\n";
        print $outfile "00000000\r\n";
        print $outfile "00000000\r\n";
        print $outfile "00000000\r\n";
        print $outfile "00000000\r\n";
        print $outfile "00000000\r\n";
        $i=0;
    }
    else {
        $i++;
    }
}

close $file;
close $outfile;



