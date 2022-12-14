require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:today) { Date.today }
  let(:yesterday) { today - 1 }
  let(:tomorrow) { today + 1 }
  let(:guest) { create(:user) }
  let(:host) { create(:user) }
  let(:room) { create(:room) }
  let(:reservation) { create(:reservation) }

  shared_context 'visualize relationship reservation' do
    let(:other_user) { create(:user) }
    let(:room_of_host) { create(:room, user: host) }
    let(:reservation_for_host_room) do
      create(:reservation,
      room: room_of_host,
      guest: guest,
      cancel: false)
    end
  end

  describe '予約バリデーション' do
    let(:reservation) { build(:reservation, room: room, guest: guest, host: host) }

    it 'チェックインが当日以前の場合、許可されないこと' do
      reservation.checkin = today
      expect(reservation).to be_invalid

      reservation.checkin = yesterday
      expect(reservation).to be_invalid
    end

    it 'チェックアウトとチェックインが同日の場合、許可されないこと' do
      reservation.checkin = tomorrow
      reservation.checkout = tomorrow
      expect(reservation).to be_invalid
    end

    it 'チェックインとチェックアウトが前後している場合、許可されないこと' do
      reservation.checkin = tomorrow + 1
      reservation.checkout = tomorrow
      expect(reservation).to be_invalid
    end

    context "同じ期間にすでに予約が入っている場合" do
      let(:two_days) { today + 2 }
      let(:three_days) { today + 3 }
      let(:four_days) { today + 4 }

      context "キャンセルは無く、進行中である場合" do
        let!(:has_reserved) do
          create(:reservation,
          room: room,
          checkin: two_days,
          checkout: three_days,
          cancel: false)
        end

        it "新規側のチェックアウトと重なる場合、許可されないこと" do
          reservation.checkin = tomorrow
          reservation.checkout = two_days
          expect(reservation).to be_invalid
        end

        it "新規側のチェックインと重なる場合、許可されないこと" do
          reservation.checkin = three_days
          reservation.checkout = four_days
          expect(reservation).to be_invalid
        end

        it "先約側の前後にチェックインとチェックアウトが設定された場合、許可されないこと" do
          reservation.checkin = tomorrow
          reservation.checkout = four_days
          expect(reservation).to be_invalid
        end
      end

      context "キャンセルされている場合" do
        let!(:canceled) do
          create(:reservation,
          checkin: two_days,
          checkout: three_days,
          cancel: true)
        end

        it "新規予約のチェックアウトと重なる場合においても、許可されること" do
          reservation.checkin = tomorrow
          reservation.checkout = two_days
          expect(reservation).to be_valid
        end

        it "新規予約のチェックインと重なる場合においても、許可されること" do
          reservation.checkin = three_days
          reservation.checkout = four_days
          expect(reservation).to be_valid
        end

        it "先約側の前後にチェックインとチェックアウトが設定された場合においても、許可されること" do
          reservation.checkin = tomorrow
          reservation.checkout = four_days
          expect(reservation).to be_valid
        end
      end
    end
  end

  describe '#stay_length' do
    let(:stay_length) { 10 }
    let(:checkin) { tomorrow }
    let(:checkout) { tomorrow + 10 }
    let(:reservation) { create(:reservation, checkin: checkin, checkout: checkout) }

    it '宿泊日数が計算できること' do
      expect(reservation.stay_length).to eq stay_length
    end

    describe '#payment' do
      let(:payment) { 25000 }
      let(:fee) { 25000 / stay_length }
      let(:room) { create(:room, fee: fee) }
      let(:reservation) do
        create(:reservation,
        checkin: checkin,
        checkout: checkout,
        room: room)
      end

      it '宿泊日数と宿泊代金に応じて料金（ユーザー支払い=オーナー利益）が計算できること' do
        expect(reservation.payment).to eq payment
      end
    end
  end

  describe '予約状況に応じた条件分岐' do
    describe '#cancel?' do
      it 'キャンセルされている場合、trueが返ること' do
        reservation.cancel = true
        expect(reservation.cancel?).to eq true
      end

      it 'キャンセルは無く進行中である場合、falseが返ること' do
        reservation.cancel = false
        expect(reservation.cancel?).to eq false
      end
    end

    describe '#cancel_requested?' do
      subject { reservation.cancel_requested? }

      it '予約に対して、ホストのキャンセルリクエストがされていない場合、falseが返ること' do
        reservation.cancel_request = false
        is_expected.to eq false
      end

      context 'キャンセルリクエストが入っている場合' do
        before do
          reservation.cancel_request = true
        end

        it '承認（ゲストによるキャンセル）がされていれば、nilが返ること' do
          reservation.cancel = true
          is_expected.to eq nil    # unlessはnilを返す
        end

        it 'されていない場合、trueが返ること' do
          reservation.cancel = false
          is_expected.to eq true
        end
      end
    end

    describe '#finished?' do
      subject { reservation.finished? }

      let(:reservation) do
        build(:reservation,
        room: room,
        guest: guest,
        host: host)
      end

      context 'チェックアウト日が本日以降の場合' do
        before do
          reservation.checkout = today
        end

        it '予約がキャンセルされている場合、nilが返ること' do
          reservation.cancel = true
          is_expected.to eq nil # unlessはnilを返す
        end

        it 'キャンセルは無く進行中の場合、falseが返ること' do
          reservation.cancel = false
          is_expected.to eq false
        end
      end

      context 'チェックアウト日が過ぎている場合' do
        it 'trueが返されること' do
          reservation.checkout = yesterday
          is_expected.to eq true
        end

        describe '#within_two_weeks_after_checkout?' do
          # 例) 1日(チェックアウト)の場合、2日 ~ 15日  =>  true

          it '本日がチェックアウトから14日以内の場合、trueが返されること' do
            reservation.checkout = today - 14.day
            expect(reservation.within_two_weeks_after_checkout?).to eq true
          end

          it '本日がチェックアウトから15日以降の場合、falseが返されること' do
            reservation.checkout = today - 15.day
            expect(reservation.within_two_weeks_after_checkout?).to eq false
          end
        end
      end
    end
  end

  describe 'ホスト、ゲスト、予約状況に応じた条件分岐' do
    include_context 'visualize relationship reservation'

    describe '#has_user_as_guest?' do
      it 'ゲスト以外のIDが渡された場合、falseが返ること' do
        expect(reservation_for_host_room.has_user_as_guest?(user_id: other_user.id)).to eq false
        expect(reservation_for_host_room.has_user_as_guest?(user_id: host.id)).to eq false
      end

      it 'ゲストIDが渡された場合、trueが返ること' do
        expect(reservation_for_host_room.has_user_as_guest?(user_id: guest.id)).to eq true
      end
    end

    describe '#has_user_as_host?' do
      it 'ホスト以外のIDが渡された場合、falseが返ること' do
        expect(reservation_for_host_room.
          has_user_as_host?(user_id: other_user.id)).to eq false
        expect(reservation_for_host_room.
          has_user_as_host?(user_id: guest.id)).to eq false
      end

      it 'ホストIDが渡された場合、trueが返ること' do
        expect(reservation_for_host_room.
          has_user_as_host?(user_id: host.id)).to eq true
      end
    end

    describe '#has_notifications_unchecked_by_host?(user_id:, **actions)' do
      shared_context 'unchecked notification by host' do
        let!(:unchecked) do
          create(:notification,
          reservation: reservation_for_host_room,
          checked: false,
          action: 'reserve')
        end
      end

      context 'ホストIDが渡された場合' do
        let!(:cancel_unchecked) do
          create(:notification,
          reservation: reservation_for_host_room,
          checked: false,
          action: 'cancel')
        end

        let!(:reserve_checked) do
          create(:notification,
          reservation: reservation_for_host_room,
          checked: true,
          action: 'reserve')
        end

        it '関連先のNotificationにおいて、actionカラムの値がオプションの値と一致し、
        かつchecked属性がfalseであるレコードが存在しない場合、falseが返ること' do
          expect(reservation_for_host_room.
            has_notifications_unchecked_by_host?(user_id: host.id, reserve: 'reserve')).to eq false
        end

        context 'falseがある場合' do
          include_context 'unchecked notification by host'

          it 'trueが返ること' do
            expect(reservation_for_host_room.
              has_notifications_unchecked_by_host?(user_id: host.id, reserve: 'reserve')).to eq true
          end
        end
      end

      context 'ホスト以外のIDが渡された場合' do
        include_context 'unchecked notification by host'

        it 'falseが返ること' do
          expect(reservation_for_host_room.
            has_notifications_unchecked_by_host?(
              user_id: other_user.id,
              reserve: 'reserve'
            )).to eq false
          expect(reservation_for_host_room.
            has_notifications_unchecked_by_host?(
              user_id: guest.id,
              reserve: 'reserve'
            )).to eq false
        end
      end
    end

    describe '#cancel_completed?' do
      context '予約がキャンセルされている場合' do
        let!(:guest_cancels_host_room) do
          create(:reservation,
          room: room_of_host,
          guest: guest,
          cancel: true)
        end

        it '第三者IDが渡された場合、falseが返ること' do
          expect(guest_cancels_host_room.
            cancel_completed?(user_id: other_user.id)).to eq false
        end

        it 'ゲストIDが渡された場合、trueが返ること' do
          expect(guest_cancels_host_room.
            cancel_completed?(user_id: guest.id)).to eq true
        end

        context 'ホストIDが渡された場合' do
          let!(:checked) do
            create(:notification,
            reservation: guest_cancels_host_room,
            checked: true,
            action: 'cancel')
          end

          it '関連先のNotificationモデルのchecked属性にfalseがない場合、trueが返ること' do
            expect(guest_cancels_host_room.cancel_completed?(user_id: host.id)).to eq true
          end

          context 'falseがある場合' do
            let!(:unchecked) do
              create(:notification,
              reservation: guest_cancels_host_room,
              checked: false,
              action: 'cancel')
            end

            it 'falseが返ること' do
              expect(guest_cancels_host_room.cancel_completed?(user_id: host.id)).to eq false
            end
          end
        end
      end

      context '予約にキャンセルは無く進行中である場合' do
        it 'ゲストIDが渡された場合も、falseが返ること' do
          expect(reservation_for_host_room.cancel_completed?(user_id: guest.id)).to eq false
        end

        context 'ホストIDが渡された場合' do
          let!(:checked) do
            create(:notification,
            reservation: reservation_for_host_room,
            checked: true,
            action: 'reserve')
          end

          it '関連先であるNotificationのcheckedカラムにfalseがない場合も、falseが返ること' do
            expect(reservation_for_host_room.cancel_completed?(user_id: host.id)).to eq false
          end
        end
      end
    end
  end

  describe '#create_notification(action:)' do
    include_context 'visualize relationship reservation'

    it 'action属性が "cancel" で登録されること' do
      reservation_for_host_room.create_notification(action: 'cancel')
      notification = Notification.where(reservation_id: reservation_for_host_room.id)
      expect(notification.first.action).to eq 'cancel'
    end

    it 'checked属性が "false" で登録されること' do
      reservation_for_host_room.create_notification(action: 'cancel')
      notification = Notification.
        where(reservation_id: reservation_for_host_room.id).
        where(action: 'cancel')
      expect(notification.first.checked).to eq false
    end

    it 'guest_idがforeign_keyとして登録されること' do
      reservation_for_host_room.create_notification(action: 'cancel')
      notification = Notification.
        where(reservation_id: reservation_for_host_room.id).
        where(action: 'cancel')
      expect(notification.first.guest_id).to eq guest.id
    end

    it 'host_idがforeign_keyとして登録されること' do
      reservation_for_host_room.create_notification(action: 'cancel')
      notification = Notification.
        where(reservation_id: reservation_for_host_room.id).
        where(action: 'cancel')
      expect(notification.first.host_id).to eq host.id
    end
  end

  describe 'has_rate?' do
    let!(:rate) { create(:rate, reservation: reservation_with_rate) }
    let!(:reservation_not_with_rate) { create(:reservation) }
    let(:reservation_with_rate) { create(:reservation) }

    it '関連付けされたRateインスタンスが存在する場合は、trueが返ること' do
      expect(reservation_with_rate.has_rate?).to eq true
    end

    it '関連付けされたRateインスタンスが存在しない場合は、falseが返ること' do
      expect(reservation_not_with_rate.has_rate?).to eq false
    end
  end
end
