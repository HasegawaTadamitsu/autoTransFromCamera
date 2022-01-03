# autoTransFromCamera

## これはなに？

gphoto2 のライブラリを用いて、Wi-fiにつなげたカメラから、
撮影済みの写真をPCに移動させます。


## 準備するもの

- gphoto2 に関するライブラリ類
- ffi-gphoto2
- ruby


## 使い方


` trans_file.rb
 ruby trans_file.rb 出力先パス IPアドレス カメラ機種名
 例　/mnt/picture 192.168.0.160`


カメラモデルはオプションです。デフォルトはCanon EOS 7D MarkII です。
カメラモデルは必ずしも実際のカメラと一致させる必要はなさそうです。
EOS 7DMarkIIの設定で、EOSR,SX730HSもOKでした。

## 説明

gphoto2のコマンドラインを当初使っていました。
ファイルリストを取得し、連続したコマンド発行で１ファイルずつダウンロード
できないこともないのですが、連続したコマンド発行は数秒間隔を開けなくてはエラーになってしまうため、
Rubyインターフェースを用いて挑戦してみました。

また、gphoto2のコマンドが一通り使えるため、タイムラプス撮影や
一眼レフやミラーレスの監視カメラなど、応用できると思います。




















