class SubstituteRoomFeeToPriceValue < ActiveRecord::Migration[6.1]
  class Room < ActiveRecord::Base
    def switch_price_range
      if fee < 5000
        1
      elsif fee < 10000
        2
      elsif fee < 20000
        3
      elsif fee < 40000
        4
      elsif fee < 60000
        5
      elsif fee < 100000
        6
      else
        7
      end
    end
  end

  class Price < ActiveRecord::Base
  end

  def up
    Room.find_each(:batch_size => 5) do |room|
      if Price.where(room_id: room.id).present?
        next
      else
        range = room.switch_price_range

        Price.create!(
          room_id: room.id,
          value: room.fee,
          range: range,
        )
      end
    end
  end

  def down
  end
end
