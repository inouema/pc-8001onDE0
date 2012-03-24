#! /usr/bin/perl
use strict;
use warnings;

# �t�@�C���̓ǂݍ���
my $filename = $ARGV[0]; #�����ɓǂݍ��݂����t�@�C�����w��.
open my $file,'<',$filename or die; #�t�@�C���ǂ݂���
binmode $file; #�o�C�i�����[�h�Ƀo�C���h
my $val;

# Zero�f�[�^��p��
open my $zerofile,'<zero.bin' or die;
binmode $zerofile;
read($zerofile, my $zero, 1);

#�o�̓t�@�C�����o�C�i�����[�h�ŗp��
open my $outfile,'> NBASIC10_format_16bit.bin' or die;
binmode $outfile;

# ��ʃo�C�g�Ƀ[��,���ʃo�C�g�Ƀf�[�^���Z�b�g���ďo��.
while(read($file, $val, 1)) {
  print $outfile $val;
  print $outfile $zero;
  printf("%02X%02X\n",unpack("C", $zero), unpack("C",$val));
}

close $file;
close $outfile;



