# 無党派層とソーシャル・ネットワーク環境

[ワーキングペーパー (4/15/2020)](Indep_SocNet_v2.pdf)

### 著者 

加藤言人 (Nazarbayev University) *gento.katoATnu.edu.kz*

## レプリケーションファイル

### 元データ

全てのファイルは一般に公開されている（一部有料）。レプリケーションを行うためには、全てのデータファイルをコードファイルと同じディレクトリに配置する。

* **ソーシャル・ネットワークと投票行動に関する調査，1993** (CNEP1993)
    * [SSJDA](https://csrda.iss.u-tokyo.ac.jp/surveybase/)からダウンロード可 (調査番号0145).
    * レプリケーション用のファイル名は<code>0145_zenkoku.sav</code>（異なる場合は改名する）

* **変動する日本人の選挙行動：1993～1996年（JESII：SPSS版）**
    * [レヴァイアサン・データバンク](http://www.bokutakusha.com/databank/index.html)から購入できる。
    * レプリケーション用のファイル名は<code>JES2.sav</code>（異なる場合は改名する）

* **21世紀初頭の投票行動の全国的・時系列的調査研究（JESIII：SSJDA版）、2001-2005**
    * [SSJDA](https://csrda.iss.u-tokyo.ac.jp/surveybase/)からダウンロード可 (調査番号0530).
    * レプリケーション用のファイル名は<code>0530BE.sav</code>（英語版のファイルを使用、ファイル名が異なる場合は改名する）

### コードファイル

全てのファイルは<code>replication_files</code>ディレクトリに含まれている。元データファイルと同じ場所にダウンロードして実行すること。

* 元データの整理・変数名変更・再保存（分析コードを実行する前に要実行）

    1. CNEP1993: [コード](replication_files/data_cnep93_1_recode_v2.R)|[出力結果](replication_files/data_cnep93_1_recode_v2.md)

    2. JESII: [コード](replication_files/data_jes2_1_recode_v2.R)|[出力結果](replication_files/data_jes2_1_recode_v2.md)

    3. JESIII: [コード](replication_files/data_jes3_1_recode_v2.R)|[出力結果](replication_files/data_jes3_1_recode_v2.md)

* 分析 

    1. メイン分析： [コード](replication_files/analysis_0_main_v2.R)|[出力結果](replication_files/analysis_0_main_v2.md)

## 著作権

このレポジトリに含まれている全ての資料・コードは、[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.ja)によって保護されています。