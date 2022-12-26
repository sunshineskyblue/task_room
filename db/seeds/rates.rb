# 低スコアを作成
low_score = {
  cleanliness: rand(3..4),
  information: rand(4..5),
  communication: rand(3..5),
  location: rand(3..4),
  price: rand(3..5),
  recommendation: rand(3..5),
  award: false
}

# 中スコアを作成
middle_score = {
  cleanliness: rand(4..5),
  information: rand(4..5),
  communication: rand(4..5),
  location: rand(4..5),
  price: rand(4..5),
  recommendation: rand(4..5),
  award: false
}

# 高いスコアを作成
high_score = {
  cleanliness: 5,
  information: rand(4..5),
  communication: rand(4..5),
  location: 5,
  price: rand(3..5),
  recommendation: rand(4..5),
  award: false
}

# オール５のスコアを作成
best_score = {
  cleanliness: 5,
  information: 5,
  communication: 5,
  location: 5,
  price: 5,
  recommendation: 5,
  award: false,
}

Reservation.all.each do |reservation|
  if reservation.rate.present?
   next
  end

  if reservation.host.name == "はるか"
    rate = Rate.new(low_score.merge({
      room_id: reservation.room.id,
      user_id: reservation.guest.id,
      reservation_id: reservation.id,
      price_range: reservation.room.price.range,
      })
    )
    
    rate.calculate_score
    rate.save!
  end

  if reservation.host.name == "こうへい"
    rate = Rate.new(middle_score.merge({
      room_id: reservation.room.id,
      user_id: reservation.guest.id,
      reservation_id: reservation.id,
      price_range: reservation.room.price.range,
      })
    )
    
    rate.calculate_score
    rate.save!
  end

  if reservation.host.name == "あきら"
    rate = Rate.new(high_score.merge({
      room_id: reservation.room.id,
      user_id: reservation.guest.id,
      reservation_id: reservation.id,
      price_range: reservation.room.price.range,
      })
    )
    
    rate.calculate_score
    rate.save!
  end

  if reservation.host.name == "ゲストユーザー"
    rate = Rate.new(best_score.merge({
      room_id: reservation.room.id,
      user_id: reservation.guest.id,
      reservation_id: reservation.id,
      price_range: reservation.room.price.range,
      })
    )
    
    rate.calculate_score
    rate.save!
  end
end

User.find_each(batch_size: 5) do |user|
  if Rate.where(user_id: user.id).where(award: true).present?
    next
  end

  Rate.find_each(batch_size: 5) do |rate|
    if rate.room.rates.where(award: true).present?
      next
    end

    if rate.reservation.guest == user
      rate.award = true
      rate.save!
      break
    end
  end
end
