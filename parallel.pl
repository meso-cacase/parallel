#!/usr/bin/perl

# ファイルまたは標準入力からコマンドリストを読み込み並列実行する
#
# Usage:  ./parallel.pl  [-MAX_PROC]  commandlist.txt
#
# MAX_PROC は並列実行するコマンドの最大数（数値）
# 省略時は 1、つまり並列化せず1行ずつ順番に実行
# コマンドリストは1行に1コマンドを記載
#
# 2012-11-08.@meso_cacase

use warnings ;
use strict ;

$| = 1 ;

# 並列実行するコマンドの最大数
my $proc_max = ($ARGV[0] =~ s/^-(\d+)$/$1/) ?
	shift @ARGV :  # 第1引数に指定されている場合はその値
	1 ;  # 省略時は 1、つまり並列化せず1行ずつ順番に実行

# コマンドリストを読み込む
my @command_list = <> ;

parallel(\@command_list, $proc_max) ;

exit ;

# ====================
sub parallel {  # コマンドリストを読み込み並列実行する
my @command_list = @{$_[0]} ;  # コマンドリストをリファレンスで与える
my $proc_max = $_[1] || 1 ;  # 並列実行するコマンドの最大数

foreach (@command_list){
	chomp ;
	if (my $pid = fork){
		# 親プロセス
		my $timestamp = timestamp() ;
		print "[$timestamp]	$pid	$_\n" ;
		$proc_max -- ;
	} else {
		# 子プロセス
		system $_ ;
		exit ;
	}
	# 並列実行するコマンドの最大数に達したらwaitする
	unless ($proc_max){
		wait ;
		$proc_max ++ ;
	}
}

# 子プロセスが無くなる、つまりwaitが-1を返すまでwaitする
while (wait != -1){ }
} ;
# ====================
sub timestamp {  # タイムスタンプを 2000-01-01 00:00:00 の形式で出力
my ($sec, $min, $hour, $mday, $mon, $year) = localtime ;
return sprintf("%04d-%02d-%02d %02d:%02d:%02d",
	$year+1900, $mon+1, $mday, $hour, $min, $sec) ;
} ;
# ====================
