#! /usr/bin/perl
use strict;
use warnings;

# ファイルの読み込み
my $filename = $ARGV[0]; #引数に読み込みたいファイルを指定.
open my $file,'<',$filename or die; #ファイル読みこみ
binmode $file; #バイナリモードにバインド
my $val;

# Zeroデータを用意
open my $zerofile,'<zero.bin' or die;
binmode $zerofile;
read($zerofile, my $zero, 1);

#出力ファイルをバイナリモードで用意
open my $outfile,'> NBASIC10_format_16bit.bin' or die;
binmode $outfile;

# 上位バイトにゼロ,下位バイトにデータをセットして出力.
while(read($file, $val, 1)) {
  print $outfile $val;
  print $outfile $zero;
  printf("%02X%02X\n",unpack("C", $zero), unpack("C",$val));
}

close $file;
close $outfile;



