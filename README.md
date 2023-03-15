# zabbix-with-oracle-deb-patch

ZabbixのDebianパッケージをOracle DBバックエンド対応で作成するためのパッチです。

## 動作確認環境

- Ubuntu 22.04
- Zabbix 6.4.0
- Oracle Instant Client 19.18

## 使い方

1. `apt source zabbix` でZabbixのソースをダウンロードする
1. `main.sh` の `SRCDIR` にダウンロードしたソースのディレクトリを指定する
1. Oracle Instant Clientを任意のフォルダに展開する
1. `main.sh` の `ORACLEDIR` にOracle Instant Clientのパスを指定する
1. `main.sh` を実行する

## ビルド方法(参考)

```bash
# ビルドのために依存パッケージのインストール
apt install devscripts equivs golang
cd /tmp/zabbix-6.4.0
mk-build-deps -i

# ビルド
debuild -us -uc
```
