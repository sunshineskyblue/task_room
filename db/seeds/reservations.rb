User.find_each(:batch_size => 5) do |user|
  Room.find_each(:batch_size => 5) do |room|
    if room.user == user
      next
    end

    if room.user.name != "ゲストユーザー"
      next
    end

    Reservation.insert_all([
      { checkin: Date.today - 2.day,
        checkout: Date.today - 1.day, 
        number: 2,
        payment: room.price.value, 
        cancel: false,
        cancel_request: false, 
        room_id: room.id,
        guest_id: user.id,
        host_id: room.user.id,
        created_at: Date.today - 3.day,
        updated_at: Date.today - 3.day,
      }
    ])
  end
end
