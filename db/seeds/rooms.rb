User
default_introduction = { introduction: "
  ★玄関の異なるマンションの2部屋です
  ★アーリーチェックイン可能（ご相談ください）
  ★渋谷駅まで14分、最寄の田園都市線三軒茶屋駅徒歩7分
  ★スマートロックで無人受付、誰にも会わずにチェックイン
  ★ゆったりサイズのダブルベッド（高品質ベッドマット使用）
  ★ヘアアイロン（ストレート・カール）、女優ミラーあり
  ★コンビニ・大型スーパー（Maruetsu）がすぐ近く、飲食店多数
  ★大画面プロジェクター完備、DVD/BDプレーヤー付き
  ★固定Wifiとプロジェクターで、遠征の思い出づくりになる、快適おしゃれな滞在をお楽しみください。
  
  ※高速道路に面しており、二重窓にて対策しておりますが、音が気になる方はご注意下さい。（無料の耳栓のご用意がございますので、ご利用ください。）"
}

room1 = {
  name: "LANG HOTEL 亀戸503 新築ホテルでNetflix鑑賞 ドンキ&コンビニ至近 バストイレ別" ,
  fee: 3456,
  adress: "富山市新総曲輪1番7号",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed.jpg")),
    filename: "seed.jpg"
  )
}

room2 = {
  name: "飛騨の古民家に泊まる" ,
  fee: 8900,
  adress: "岐阜県飛騨市古川町本町２−２２",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed2.jpg")),
    filename: "seed2.jpg"
  )
}

room3 = {
  name: "【NEW】浅草/東京スカイツリー直通！八広駅徒歩3分 2階建て一軒家 4ベッド WIFI無制限" ,
  fee: 13500,
  adress: "東京都新宿区西新宿2-8-1",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed3.jpg")),
    filename: "seed3.jpg"
  )
}

room4 = {
  name: "【1日1組限定4名まで同額】宮川沿いの町家一棟貸切ステイ　～WAT RESORT 飛騨まちやど 桜～" ,
  fee: 24000,
  adress: "岐阜市薮田南2丁目1番1号",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed4.jpg")),
    filename: "seed4.jpg"
  )
}

room5 = {
  name: "都会の喧騒からは程遠い、清流のある小さな村(1日1組限定)" ,
  fee: 34500,
  adress: "石川県金沢市鞍月1丁目1番地",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed5.jpg")),
    filename: "seed5.jpg"
  )
}

room6 = {
  name: "静かな別荘地の一番奥の森の中にある、小さな別荘　Westwood Takayama" ,
  fee: 55000,
  adress: "和歌山市小松原通一丁目1番地",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed6.jpg")),
    filename: "seed6.jpg"
  )
}

room7 = {
  name: "【Pop Culture House】一軒家貸切！インスタ映えの宿！最大10名★駐車場3台無料☆" ,
  fee: 67400,
  adress: "三重県津市広明町13番地",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed7.jpg")),
    filename: "seed7.jpg"
  )
}

room8 = {
  name: "山荘民宿" ,
  fee: 170000,
  adress: "岐阜県飛騨市２",
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed2.jpg")),
    filename: "seed2.jpg"
  )
}

User.find_each(:batch_size => 1) do |user|
  if user.name != "ゲストユーザー"
    next
  end

  user_id = {user_id: user.id}

  Room.create!(default_introduction.merge(room8).merge(user_id))
end
