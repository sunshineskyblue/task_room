class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!

  def score
  end
end
