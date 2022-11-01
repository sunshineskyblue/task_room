class TopController < ApplicationController
  def index
    if session[:form_data].present?
      session.delete("form_data")
    end
  end
end
