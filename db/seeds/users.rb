ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter = :inline

User.create!({
  email: guest_user@example.com
  password: "guest_user"
  name: "ゲストユーザー"
  introduction: "こちらはゲストユーザーのアカウントとなります。"
  image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/guest_user.jpg")),
    filename: "guest_user.jpg"
})

User.create!({
  email: user1@example.com
  password: "user1_user"
  name: "あきら"
  introduction: "初めまして。あきらと申します。今回初めてlife in pocketでホストとして物件を登録しておりますが、以前に他のサービスで貸別荘を提供していましたので、スムーズな対応ができるかと思います。よろしくお願いたします。"
  image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed2.jpg")),
    filename: "user1.jpg"
})

User.create!({
  email: guest_user@example.com
  password: "user2_user"
  name: "はるか"
  introduction: "初めまして。はるかと申します。ゲスト、ホストの両方でlife in pocketを利用しています"
  image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/seed2.jpg")),
    filename: "user2.jpg"
})
