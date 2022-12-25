ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter = :inline

default_introduction = { introduction: "★玄関の異なるマンションの2部屋です
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

samples = [
  { 
    room: {
      name: "LANG HOTEL 亀戸503 新築ホテルでNetflix鑑賞 ドンキ&コンビニ至近 バストイレ別" ,
      fee: 4999,
      adress: "富山市新総曲輪1番7号",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room1.jpg")),
        filename: "room1.jpg"
      )
    },
    price: { value: 4999 },
  },

  {
    room: {
      name: "飛騨の古民家に泊まる" ,
      fee: 9999,
      adress: "岐阜県飛騨市古川町本町２−２２",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room2.jpg")),
        filename: "room2.jpg"
      )
    },
    price: { value: 9999 },
  },

  {
    room: {
      name: "【NEW】浅草/東京スカイツリー直通！八広駅徒歩3分 2階建て一軒家 4ベッド WIFI無制限" ,
      fee: 19999,
      adress: "東京都新宿区西新宿2-8-1",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room3.jpg")),
        filename: "room3.jpg"
      )
    },
    price: { value: 19999 },
  },

  {
    room: {
      name: "【NEW】浅草/東京スカイツリー直通！八広駅徒歩3分 2階建て一軒家 4ベッド WIFI無制限" ,
      fee: 19999,
      adress: "東京都新宿区西新宿2-8-1",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room3.jpg")),
        filename: "room3.jpg"
      )
    },
    price: { value: 19999 },
  },
  
  {
    room: {
      name: "【1日1組限定4名まで同額】宮川沿いの町家一棟貸切ステイ　～WAT RESORT 飛騨まちやど 桜～" ,
      fee: 39999,
      adress: "岐阜市薮田南2丁目1番1号",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room4.jpg")),
        filename: "room4.jpg"
      )
    },
    price: { value: 39999 },
  },
  
  {
    room: {
      name: "都会の喧騒からは程遠い、清流のある小さな村(1日1組限定)" ,
      fee: 59999,
      adress: "石川県金沢市鞍月1丁目1番地",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room5.jpg")),
        filename: "room5.jpg"
      )
    },
    price: { value: 59999 },
  },
  
  {
    room: {
      name: "静かな別荘地の一番奥の森の中にある、小さな別荘　Westwood Takayama" ,
      fee: 99999,
      adress: "和歌山市小松原通一丁目1番地",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room6.jpg")),
        filename: "room6.jpg"
      )
    },
    price: { value: 99999 },
  },
  
  {
    room: {
      name: "【Pop Culture House】一軒家貸切！インスタ映えの宿！最大10名★駐車場3台無料☆" ,
      fee: 100000,
      adress: "三重県津市広明町13番地",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room7.jpg")),
        filename: "room7.jpg"
      )
    },
    price: { value: 100000 },
  },
  
  {
    room: {
      name: "山荘民宿" ,
      fee: 170000,
      adress: "岐阜県飛騨市２",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("db/fixtures/room2.jpg")),
        filename: "room2.jpg"
      )
    },
    price: { value: 170000 },
  },
]


User.find_each(:batch_size => 1) do |user|
  if user.name != "はるか"
    next
  end

  samples.each do |sample|
    user_id = {user_id: user.id}
    room = Room.create!(default_introduction.merge(sample[:room]).merge(user_id))

    binding.pry
    
    price = Price.new(
      room_id: room.id,
      value: sample[:price][:value],
    )

    price.switch_price_range
    price.save!
  end
end
