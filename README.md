parallel.pl
======================

ファイルまたは標準入力からコマンドリストを読み込み並列実行するperlスクリプト。  
並列実行するコマンドの最大数をコマンド引数から指定できます。
 (from [gist:4037338](https://gist.github.com/4037338))

`xargs -P` や GNU `parallel` でも同様のことができますが、perlスクリプト内で  
並列実行したい場合に本レポジトリのコードを流用できます。

使い方
-----

並列実行するコマンドの最大数を3に指定して実行する例：

```bash
% ./parallel.pl -3 commandlist.txt
```

結果：

```
[2018-10-21 11:15:50]	29887	sleep 7 ; echo "command #1 done."
[2018-10-21 11:15:50]	29888	sleep 2 ; echo "command #2 done."
[2018-10-21 11:15:50]	29890	sleep 2 ; echo "command #3 done."
command #3 done.
command #2 done.
[2018-10-21 11:15:52]	29896	sleep 3 ; echo "command #4 done."
[2018-10-21 11:15:52]	29897	sleep 4 ; echo "command #5 done."
command #4 done.
[2018-10-21 11:15:55]	29902	sleep 3 ; echo "command #6 done."
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

`parallelhost.pl` 内の ```@host_list``` で計算ノードリストを指定します。

参考
--------
`xargs -P` や GNU `parallel` でも同様のことができます。

### xargs -P の利用 ###

`xargs` を使って `sh -c {}` に渡すとコマンドとして実行できます。  
`-t` で実行されるコマンドを標準エラー出力に表示し、`-P` で並列数を指定できます。

```bash
% cat commandlist.txt | xargs -t -P 3 -I{} sh -c {}
```

### GNU parallel の利用 ###

`-t` で実行されるコマンドを標準エラー出力に表示し、`-P` で並列数を指定できます。

```bash
% cat commandlist.txt | parallel -t -P 3
```

License
--------

Copyright &copy; 2012-2024 Yuki Naito
 ([@meso_cacase](https://twitter.com/meso_cacase))  
This software is distributed under
[modified BSD license](https://www.opensource.org/licenses/bsd-license.php).
