#! /usr/bin/perl
use strict;
use warnings;

# 8x8�̃t�H���g�f�[�^��8x16�Ƀ��T�C�Y���܂�.

# �t�@�C���̓ǂݍ���
my $filename = $ARGV[0]; #�����ɓǂݍ��݂����t�@�C�����w��.
open my $file,'<',$filename or die; #�t�@�C���ǂ݂���
my $val;

#�o�̓t�@�C����p��
open my $outfile,'> cgrom8x16.txt' or die;


my $i=0;

# 8�s�ǂݍ��񂾂� 8�s�[���p�f�B���O���܂�.
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



