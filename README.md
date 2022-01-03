# autoTransFromCamera

## これはなに？

gphoto2 のライブラリを用いて、Wi-fiにつなげたカメラから、
撮影済みの写真をPCに移動させます。


##準備するもの

gphoto2 に関するライブラリ類
ffi-gphoto2
ruby


##使い方

 ruby trans_file.rb 出力先パス IPアドレス カメラ機種名
 例　/mnt/picture 192.168.0.160
 


カメラモデルはオプション。デフォルトはCanon EOS 7D MarkII です。
カメラモデルは必ずしも実際のカメラと一致させる必要はなさそうです。
EOS 7DMarkIIの設定で、EOSR,SX730HSもOKでした。














