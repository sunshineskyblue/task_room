require 'rails_helper'

RSpec.describe "Rooms", type: :system do
  let(:user) { create(:user) }
  let(:name) { "テスト用サンプル" }
  let(:introduction) { "とても広い部屋があります" }
  let(:adress) { "神奈川県横浜市" }
  let(:fee) { 1000 }

  describe "登録機能" do
    before do
      sign_in user
      visit create_rooms_path
      fill_in "登録名", with: name
      fill_in "物件紹介", with: introduction
      fill_in "住所", with: adress
      fill_in "料金/泊", with: fee
      attach_file "ルーム画像", "#{Rails.root}/spec/fixtures/files/images/test.jpg"
      click_on "登録する"
    end

    it "DBに登録されていること" do
      room = Room.find_by(name: name)
      # 画像登録については、blobモデルを通してfilenameで照合   //TODO:照合方法は今後要検討
      img = room.room_image.blob.filename

      expect(room.introduction).to eq introduction
      expect(room.adress).to eq adress
      expect(room.fee).to eq fee
      expect(img).to eq "test.jpg"
    end

    #  Roomの正規化に伴い、Priceテーブルを追加。今後、feeカラム値については、valueカラムに移行する
    #  段階としてfeeカラムの登録時に、Priceインスタンスが登録されるように修正したため、テスト追加
    it "Priceインスタンスが登録されていること" do
      room = Room.find_by(name: name)
      price = room.price

      expect(price).to be_instance_of(Price)
      expect(price.value).to eq room.fee
    end

    it '紹介ページに切り替わり、物件の登録内容が表示されること' do
      room = Room.find_by(name: name)

      within ".room-detail-wrapper" do
        expect(page).to have_selector("img[src$='test.jpg']")
        expect(page).to have_content room.name
        expect(page).to have_content room.introduction
        expect(page).to have_content room.adress
      end

      within ".reservation-entry-form-container" do
        expect(page).to have_content room.fee
      end
    end
  end
end
