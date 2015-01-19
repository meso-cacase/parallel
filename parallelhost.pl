#!/usr/bin/perl

# ファイルまたは標準入力からコマンドリストを読み込み複数ノードで並列実行する
#
# Usage:  ./parallel.pl  commandlist.txt
#
# @host_list は計算ノードのリスト
# コマンドリストは1行に1コマンドを記載
#
# 2015-01-14 Yuki Naito (@meso_cacase)

use warnings ;
use strict ;

$| = 1 ;

# 計算ノード一覧
my @host_list = ('s01','s02','s03','s04','s05','s06','s07','s08') ;

# コマンドリストを読み込む
my @command_list = <> ;

parallel(\@command_list, \@host_list) ;

exit ;

# ====================
sub parallel {  # コマンドリストを読み込み並列実行する
my @command_list = @{$_[0]} ;  # コマンドリストをリファレンスで受け取る
my @host_list    = @{$_[1]} ;  # 計算ノードリストをリファレンスで受け取る

my %host ;
foreach (@command_list){
	chomp ;
	my $host = shift @host_list ;  # @host_list が空きノード一覧となる
	if (my $pid = fork){
		# 親プロセス
		print "$pid | ssh $host \'$_\'\n" ;
		$host{$pid} = $host ;
	} else {
		# 子プロセス
		system("ssh $host \'$_\'") ;
		exit ;
	}
	# 並列実行するコマンドの最大数に達したらwaitする
	unless (@host_list){
		my $pid = wait ;
		push @host_list, $host{$pid} ;
	}
}

# 子プロセスが無くなる、つまりwaitが-1を返すまでwaitする
while (wait != -1){ }
} ;
# ====================
