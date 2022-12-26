# Life in Pocket
空き物件の貸し借りサービスを想定・模倣したサイトです。</br>
一つのアカウントでホスト、ゲストとしてご利用頂けます。</br>
ゲストログイン機能を備えているため、どなたでもこのアカウントから宿泊予約、</br>
あるいはホストとして物件の登録をお試し頂けます。

<img width="1267" alt="スクリーンショット 2022-12-26 13 40 21" src="https://user-images.githubusercontent.com/109893844/209501020-de96acbc-74ae-4397-b73b-7836f0c053b1.png">

<img width="259" alt="screen shot" src="https://user-images.githubusercontent.com/109893844/209503347-ef2c5034-3ec5-47bb-b652-9a91e8010861.png">


# URL
https://sunshineskyblue-20221225230053.herokuapp.com/


# 使用技術
- Ruby  3.0.4
- Ruby on Rails  6.1.7
- JQuery
- Bootstrap
- AWS
  - EC2
- DB
  - Sqlite3（local)
  - MySQL（production）
- circleci
- RSpec
- Rubocop Airbnb
- Heroku


# 機能一覧
- ログイン機能（devise）
- 検索機能（ransack)
- 予約機能
- お知らせ機能
- レビュー機能（raty）
- 画像機能（Active Storage）
- ページネーション機能（kaminari）


# テスト
- Rspec
  - 単体テスト（model）
  - システムテスト（system）

# インフラ構築
- Githubへのpush時に、Herokuへの自動デプロイが実行されます。

# ER図
<img width="796" alt="スクリーンショット 2022-12-26 13 15 11" src="https://user-images.githubusercontent.com/109893844/209499228-e9e400a6-2ff3-4f84-8e6a-a8b8a6a0bcbc.png">

# こだわりポイント
- **価格帯に応じた平均スコアの表示**</br>
通常の星レビュー機能に加え、宿泊価格に応じてその価格帯ごとの平均スコアが表示されます。</br>
ユーザーが価格帯ごとに公正な評価が可能となることを目的としています。</br>
これは宿泊価格がサービスの品質や宿泊体験に一定の影響を与えていると仮定した場合、</br>
通常の星レビューでは価格が異なる物件同士が星の数という指標のみで比較されてしまい、</br>
安価な物件が不利となってしまうと考えたからです。

- **キャンセル・キャンセルリクエスト機能**</br>
インターアクティブな機能として、ゲスト・ホストの双方から予約に対してキャンセルすることが可能です。</br>
仕組み上、ホストの場合はキャンセルリクエストという形でゲストにリクエストを送り、</br>
ゲストに承認を求めるような作りとなっております。</br>
お知らせ機能とも連動し、予約時含めキャンセルあるいはキャンセルリクエストが入った場合は、</br>
それぞれに通知が入ります。

