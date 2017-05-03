class UsageController < ApplicationController
  def index
    @secret_url = params[:secret_url]
  end
end
