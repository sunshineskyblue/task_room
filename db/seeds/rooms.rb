default_introduction = { introduction: "お部屋について
  ＜家具付き全個室　即日入居・宿泊可＞長期滞在 割引メッセージにてご相談下さい。サザンビーチまで歩いてすぐ。朝から開いている海が目の前のカフェ(wifi有)などでPC作業や朝食をとったり海岸をのんびり散歩したり、海の側で自分のペースでゆっくりするの適した家です。
  
  Free無料
  歯ブラシ、バスタオル・バスローブレンタル。
  メイク落とし、泡洗顔、化粧水、使い捨てスリッパ・ボディスポンジ。
  
  海のサイクリングロード(江の島まで30分)でサイクリング、ビーチヨガ、サーフィンや釣りなどに適した立地。おすすめは海で読書したり月光浴、朝陽や夕陽を観ながらぼ～っとする事です。：）茅ヶ崎漁港海岸公園◎徒歩数分
  
  自転車で2分～8分
  セブンイレブン、スーパー、100円ショップ
  漁師居酒屋、窯焼きピザ、クラフトビールのお店他"
}

room1 = {
  name: "1棟貸切!最大10名【デッキでBBQ&石風呂&100型映画&暖炉】車で4分!那須ハイランド、那須観光" ,
  fee: 4500,
  adress: " 栃木県那須郡那須町湯本2-15",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed.jpg")),
    filename: "seed.jpg"
  )
}

room2 = {
  name: "Apple farmers house 農村の中にある静かな蔵の宿" ,
  fee: 8000,
  adress: "高知市丸ノ内1丁目2番20号",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed2.jpg")),
    filename: "seed2.jpg"
  )
}

room3 = {
  name: "ペットも一緒に泊まれるデザイナーズ住宅！" ,
  fee: 12000,
  adress: "東京都新宿区西新宿2-8-1",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed3.jpg")),
    filename: "seed3.jpg"
  )
}

room4 = {
  name: "海にすぐ近く！ キャンプができる豪華ベランダ付き" ,
  fee: 21000,
  adress: "那覇市泉崎1-2-2",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed4.jpg")),
    filename: "seed4.jpg"
  )
}

room5 = {
  name: "東京ディズニーまで電車で10分! 送迎バスあり" ,
  fee: 37000,
  adress: "千葉市中央区市場町1番1号 ",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed5.jpg")),
    filename: "seed5.jpg"
  )
}

room6 = {
  name: "【天然温泉付き1日1組限定】 THE LODGE 弟子屈 〜 摩周湖の秘境 〜 ※テラスBBQ付き" ,
  fee: 50000,
  adress: "札幌市中央区北3条西6丁目 ",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed6.jpg")),
    filename: "seed6.jpg"
  )
}

room7 = {
  name: "hallelujah yoichi guesthouse 余市ゲストハウス　はれるや" ,
  fee: 67000,
  adress: "岐阜市薮田南2丁目1番1号",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed7.jpg")),
    filename: "seed7.jpg"
  )
}

room8 = {
  name: "カップルやファミリーにぴったり。エレガントで閑静なログハウス" ,
  fee: 140000,
  adress: "長野市大字南長野字幅下692-2",
  user_id: 11,
  room_image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed2.jpg")),
    filename: "seed2.jpg"
  )
}

# TODO: each構文におけるDBエラー(Busy exception)により、取り急ぎ対応
if Room.create!(default_introduction.merge(room1))
  if Room.create!(default_introduction.merge(room2))
    if Room.create!(default_introduction.merge(room3))
      if Room.create!(default_introduction.merge(room4))
        if Room.create!(default_introduction.merge(room5))
          if Room.create!(default_introduction.merge(room7))
            Room.create!(default_introduction.merge(room8))
          end
        end
      end
    end
  end
end
