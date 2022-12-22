class RatesController < ApplicationController
  def create
    rate = Rate.new(rate_params)
    rate.user_id = current_user.id
    rate.calculate_score

    if rate.save
      flash[:notice] = "送信が完了しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:errors] = rate.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def rate_params
    params.require(:rate).permit(
      :room_id,
      :user_id,
      :reservation_id,
      :price_category,
      :price_value,
      :cleanliness,
      :information,
      :communication,
      :location,
      :price,
      :recommendation,
      :award
    )
  end
end
