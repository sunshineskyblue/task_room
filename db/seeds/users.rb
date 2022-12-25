ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter = :inline

User.create!({
  email: "guest_user@example.com",
  password: "guest_user",
  password_confirmation: "guest_user",
  name: "ゲストユーザー",
  introduction: "こちらはゲストユーザーのアカウントとなります。",
  image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/guest_user.jpg")),
    filename: "guest_user.jpg")
})

User.create!({
  email: "akira@example.com",
  password: "akira_password",
  password_confirmation: "akira_password",
  name: "あきら",
  introduction: "初めまして。あきらと申します。この度はお取引のほどよろしくお願い致します。",
  image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/user1.jpg")),
    filename: "user1.jpg")
})

User.create!({
  email: "haruka@example.com",
  password: "haruka_password",
  password_confirmation: "haruka_password",
  name: "はるか",
  introduction: "初めまして。はるかと申します。この度はお取引のほどよろしくお願い致します。",
  image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/user2.jpg")),
    filename: "user2.jpg")
})

User.create!({
  email: "kohei@example.com",
  password: "kohei_password",
  password_confirmation: "kohei_password",
  name: "航平",
  introduction: "初めまして。航平と申します。この度はお取引のほどよろしくお願い致します。",
  image: ActiveStorage::Blob.create_and_upload!(
    io: File.open(Rails.root.join("db/fixtures/user3.jpg")),
    filename: "user3.jpg")
})
