parallel.pl
======================

ファイルまたは標準入力からコマンドリストを読み込み並列実行するperlスクリプト。  
並列実行するコマンドの最大数をコマンド引数から指定できます。
 (from [gist:4037338](https://gist.github.com/4037338))

xargs -P や GNU parallel でも同様のことができますが、perlスクリプト内で  
並列実行したい場合に本レポジトリのコードを流用できます。

使い方
-----

並列実行するコマンドの最大数を3に指定して実行する例：

```bash
% ./parallel.pl -3 commandlist.txt
```

結果：

```
77268	sleep 7 ; echo "command #1 done."
77269	sleep 2 ; echo "command #2 done."
77270	sleep 2 ; echo "command #3 done."
command #2 done.
command #3 done.
77277	sleep 3 ; echo "command #4 done."
77278	sleep 4 ; echo "command #5 done."
command #4 done.
77283	sleep 3 ; echo "command #6 done."
(以下省略)
```

コマンドの前の数値はプロセスIDです。

コマンドリストを標準入力から与えることもできます：

```bash
% head -10 commandlist.txt | ./parallel.pl -3
```

応用：複数ノードでの分散処理
-----

コマンドリスト内のジョブを複数のノードに振り分けて効率よく実行します。  
各ノードでは1ジョブずつ実行し、終了したら次のジョブが投入されます。

```bash
% ./parallelhost.pl commandlist.txt
```

parallelhost.pl 内の ```@host_list``` で計算ノードリストを指定します。

参考
--------

xargs -P や GNU parallel でも同様のことができます。

### xargs -P の利用 ###

xargs の -i オプションを指定し sh -c {} に渡すとコマンドとして実行できます。  
-t で実行されるコマンドを標準エラー出力に表示し、-P で並列数を指定できます。

```bash
% cat commandlist.txt | sed 's/"/\\"/g' | xargs -t -P 3 -i sh -c {}
```

### GNU parallel の利用 ###

-t で実行されるコマンドを標準エラー出力に表示し、-P で並列数を指定できます。

```bash
% cat commandlist.txt | parallel -t -P 3
```

ライセンス
--------

Copyright &copy; 2012-2015 Yuki Naito
 ([@meso_cacase](http://twitter.com/meso_cacase))  
This software is distributed under
[modified BSD license](http://www.opensource.org/licenses/bsd-license.php).
