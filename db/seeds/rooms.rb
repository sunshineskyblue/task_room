ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter = :inline

default_introduction = { introduction: "『〇〇ハウス』でYoutube検索！
  〇〇ICから車で5分。東京から1時間ちょっとのアクセスの良さ。水は富士山麓の美味しい水。小川の流れる暖炉のあるログハウス別荘丸々一棟貸で、ゆったり時間楽しみませんか?

  庭でバーベキューや薪割り体験。室内もOKで冬も暖炉の炎を眺めながら語らい合うと心も身体も温もります。
  小川を望みながらハンモックで寛げます。
  120インチのホームシアターで映画も楽しめます。

  スーパーや大型のホームセンターなども車で数分なので買い出しにも困りません。

  旅行に、友達やカップルの遊びに、会社の研修や保養所として、クラブやサークル活動、静かな場所での田舎暮らし体験など様々なシーンでご利用下さい。

  非日常の静かな田舎でゆっくり寛ぎたい方、東京からも通える距離の非日常空間へ！

  《人気の近隣観光地》
  ☆観光地へ最適☆
  河口湖、山中湖、富士山
  富士急ハイランド、富士すばるランド、富士サファリパーク
  富士リゾートカントリークラブ
  中央都留カントリークラブ
  都留カントリークラブなど"
}

samples = [
  { 
    room: {
      name: "LANG HOTEL 亀戸503 新築ホテルでNetflix鑑賞 ドンキ&コンビニ至近 バストイレ別" ,
      fee: 4999,
      adress: "富山市新総曲輪1番7号",
      number: 1,
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room1.jpg"),
        filename: "room1.jpg"
      )
    },
    price: { value: 4999 },
  },

  {
    room: {
      name: "飛騨の古民家に泊まる" ,
      fee: 9999,
      number: 2,
      adress: "岐阜県飛騨市古川町本町２−２２",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room2.jpg"),
        filename: "room2.jpg"
      )
    },
    price: { value: 9999 },
  },

  {
    room: {
      name: "【NEW】浅草/東京スカイツリー直通！八広駅徒歩3分 2階建て一軒家 4ベッド WIFI無制限" ,
      fee: 19999,
      number: 3,
      adress: "東京都新宿区西新宿2-8-1",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room3.jpg"),
        filename: "room3.jpg"
      )
    },
    price: { value: 19999 },
  },
  
  {
    room: {
      name: "【1日1組限定4名まで同額】宮川沿いの町家一棟貸切ステイ　～WAT RESORT 飛騨まちやど 桜～" ,
      fee: 39999,
      number: 4,
      adress: "岐阜市薮田南2丁目1番1号",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room4.jpg"),
        filename: "room4.jpg"
      )
    },
    price: { value: 39999 },
  },
  
  {
    room: {
      name: "都会の喧騒からは程遠い、清流のある小さな村(1日1組限定)" ,
      fee: 59999,
      number: 5,
      adress: "石川県金沢市鞍月1丁目1番地",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room5.jpg"),
        filename: "room5.jpg"
      )
    },
    price: { value: 59999 },
  },
  
  {
    room: {
      name: "静かな別荘地の一番奥の森の中にある、小さな別荘　Westwood Takayama" ,
      fee: 99999,
      number: 6,
      adress: "和歌山市小松原通一丁目1番地",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room6.jpg"),
        filename: "room6.jpg"
      )
    },
    price: { value: 99999 },
  },
  
  {
    room: {
      name: "【Pop Culture House】一軒家貸切！インスタ映えの宿！最大10名★駐車場3台無料☆" ,
      fee: 100000,
      number: 7,
      adress: "三重県津市広明町13番地",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room7.jpg"),
        filename: "room7.jpg"
      )
    },
    price: { value: 100000 },
  },
  
  {
    room: {
      name: "山荘民宿" ,
      fee: 170000,
      number: 8,
      adress: "岐阜県飛騨市２",
      room_image: ActiveStorage::Blob.create_and_upload!(
        io: File.open("#{File.dirname(__FILE__)}/fixtures/room2.jpg"),
        filename: "room2.jpg"
      )
    },
    price: { value: 170000 },
  },
]


User.find_each(:batch_size => 1) do |user|
  samples.each do |sample|
    user_id = {user_id: user.id}
    room = Room.create!(default_introduction.merge(sample[:room]).merge(user_id))
    
    price = Price.new(
      room_id: room.id,
      value: sample[:price][:value],
    )

    price.switch_price_range
    price.save!
  end
end
