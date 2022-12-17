Room.find_each(:batch_size => 5) do |room|
  if room.price.present?
    next
  end

  price = Price.new(
    room_id: room.id,
    value: room.fee,
  )

  price.switch_price_range
  price.save!
end
