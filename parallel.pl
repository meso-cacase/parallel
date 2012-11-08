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

# コマンドリストを1行ずつ読み込み実行する
foreach (<>){
	chomp ;
	if (my $pid = fork){
		# 親プロセス
		print "$pid	$_\n" ;
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

exit ;
