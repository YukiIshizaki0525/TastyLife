# TastyLife

Link: https://tasty-life.site/

ポートフォリオを制作した背景
---
私自身一人暮らしで、日々自炊を行っていて、以下のことが<font color="Red">課題</font>と感じています。

1. 作る料理がマンネリ化してしまい、モチベーションが下がり、自炊を突然やめてしまう
2. 一人暮らしの自炊についての相談できる機会がない
3. 冷蔵庫に保管している食材を管理できていないため、腐らせてしまったり余っているのに買ってしまう

上記課題を解決できる<font color="Red">自炊のモチベーションアップや悩みが解決できるアプリケーション　</font>を作成しようと決意しました。

使用イメージ
---
全てのページが <font color="Red">レスポンシブデザイン</font>となっておりますが、
GIFはPCサイズとなっております。

ゲストログイン
---
- ゲストユーザーは多くの人が使うアカウントであるため、ゲストユーザーアカウントのみ編集削除ができない仕様になっており、退会処理もできない仕様になっています。

![guest_login](https://user-images.githubusercontent.com/60068515/128622267-6f091465-d7a1-4543-9137-1d3093dc448d.gif)

レシピ投稿/タグ付け
---
- 材料と作り方はレシピによりそれぞれのため、非同期でフォームを追加削除できます
- レシピの完成イメージはあらかじめ確認したいため、画像プレビューされます

![recipe_submit](https://user-images.githubusercontent.com/60068515/128622186-f191a6bb-2122-4789-b3d8-49035c01e1d1.gif)

相談投稿
---
- 投稿する内容が掴みにくいため、投稿しやすい様にプレスホルダーに投稿内容サンプルを記載

![consultation_submit](https://user-images.githubusercontent.com/60068515/128622193-624d0b6a-b6b6-4475-80be-5ed202bda0d0.gif)

食材登録
---
- 登録した食材の個数や賞味期限を確認できるため、無駄な買い足しや廃棄を防止できます。

![inventory](https://user-images.githubusercontent.com/60068515/128622239-b2805da1-f880-4c6d-b749-cf21d5db362d.gif)

タグ検索
---
- 気分に合わせてサッとレシピを決めたい時に有効です。
- タグの種類を限定し既定6つのタグから検索が可能です。

![tag_search](https://user-images.githubusercontent.com/60068515/128622279-6f41b20d-e9d3-4692-9ad4-3b3989279238.gif)

相談ソート
---
- 関心のある相談や回答数の多い相談を見つけるきっかけとなり、新しい発見により私生活にも活かせます。

![sort_consultation](https://user-images.githubusercontent.com/60068515/128622285-e62cae45-b9ef-4fe1-919a-a00fd831a196.gif)

使用技術
---
フロントエンド
HTML/CSS/Sass/JavaScript(ES6)

バックエンド
Ruby 2.6.5/Rails 6.0.3

テスト基盤
RSpec 3.9/FactoryBot 4.10.0

データベース
MySQL 5.7

インフラ
Docker 20.10.7/Docker Compose 1.29.2
AWS(VPC, EC2, IAM, RDS, InternetGataway, SecurityGroup, Subnet, Route53, ALB, ACM, S3)
Nginx 1.15.8

AWS構成図
---
![TastyLife_AWS](https://user-images.githubusercontent.com/60068515/128622459-fc46a5f3-474b-4c9f-879c-5bfd8649ab12.jpg)

ER図
---
![ER_TastyLife](https://user-images.githubusercontent.com/60068515/128622461-7d13a4ea-0ece-4a4b-ab17-dcecdd75419f.png)


機能一覧
---
全３4機能があり、自炊でのモチベーションアップ、悩み解決に貢献できます。
今後も、オリジナリティあふれる機能を増やしていきます。
<img width="1155" alt="ポートフォリオ機能一覧" src="https://user-images.githubusercontent.com/60068515/128622434-2ab6a4e3-c793-4455-95ba-1c16efbdd5c0.png">


                     
工夫点
---
UI/UX
---
サイトのUI/UXが整っていないと、不信感が高まり、機能を実際に使ってもらえないと思ったため
色には統一感を持たせ、統一感のある見やすいデザインにしました。
私生活ではスマホでレシピ検索したり、レシピを見ながら料理することが多いため、
スマホでも違和感なく見れるようレスポンシブデザインにしました。


　　✔︎レスポンシブデザイン  
　　✔︎ページタイトル、文字色、ボーダー等の色を統一  
　　✔︎直感的な操作  
　　✔︎多彩なアクションで動きのあるサイト  
　　✔︎導線設計  

機能面
---
私自身、自炊の相談がしにくい・食材が管理できないなどの課題があったため
それに対応できるよう相談投稿や食材管理機能を追加し、一般的なレシピサイトとの差別化を図りました。

レシピがすぐに決まらず、めんどくさくて作らなかった場面も多々あったので、
レシピをすぐ決めて、自炊継続できるようタグ検索、ワード検索機能を追加しました。


　　✔︎大手レシピサイトとの差別化  
　　✔︎作りたい料理をタグで探せる  
　　✔︎関心のある相談をソートして見れる  
　　✔︎保管中の食材の管理無駄遣い防止  


テスト
---
バリデーションや機能がうまく動作しているか自分で確認しきれないことが多く、コードに信頼性を持たせるため、単体テストと統合テストを多く実装しました。

ModelSpec結果  
<img width="478" alt="modelspec_result_0710" src="https://user-images.githubusercontent.com/60068515/128622593-f8ab4e4f-5462-47e6-8592-f56082765537.png">

SystemSpec結果  
<img width="498" alt="systemspec_result_0710" src="https://user-images.githubusercontent.com/60068515/128622594-37d05d25-fa25-4daf-b30c-f29da1c6dbeb.png">


　　✔︎コードに信頼性を持たせ、ユーザーに安心して使ってもらえるようにRSpecで十分なテストの実施  







