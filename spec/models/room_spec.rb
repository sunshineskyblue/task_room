require 'rails_helper'

RSpec.describe Room, type: :model do
  let!(:room) { create(:room) }

  describe '#create_price!' do
    it 'Priceインスタンスが登録されること' do
      expect(room.create_price!).to be_instance_of(Price)
    end

    it 'Roomのfeeカラム値がPriceのvalueカラム値と同一となること' do
      price = room.create_price!
      expect(room.fee).to eq price.value
    end

    context 'feeカラム値の値が5000円未満の場合' do
      it 'rangeカラムが1で登録されること' do
        room.fee = 4999
        price = room.create_price!
        expect(price.range).to eq 1
      end
    end

    context 'feeカラム値の値が1万円未満の場合' do
      it 'rangeカラムが1で登録されること' do
        room.fee = 9999
        price = room.create_price!
        expect(price.range).to eq 2
      end
    end

    context 'feeカラム値の値が2万円未満の場合' do
      it 'rangeカラムが1で登録されること' do
        room.fee = 19999
        price = room.create_price!
        expect(price.range).to eq 3
      end
    end

    context 'feeカラム値の値が4万円未満の場合' do
      it 'rangeカラムが1で登録されること' do
        room.fee = 39999
        price = room.create_price!
        expect(price.range).to eq 4
      end
    end

    context 'feeカラム値の値が6万円未満の場合' do
      it 'rangeカラムが1で登録されること' do
        room.fee = 59999
        price = room.create_price!
        expect(price.range).to eq 5
      end
    end

    context 'feeカラム値の値が10万円未満の場合' do
      it 'rangeカラムが1で登録されること' do
        room.fee = 99999
        price = room.create_price!
        expect(price.range).to eq 6
      end
    end

    context 'feeカラム値の値が10万円以上の場合' do
      it 'rangeカラムが1で登録されること' do
        room.fee = 100000
        price = room.create_price!
        expect(price.range).to eq 7
      end
    end
  end
end
