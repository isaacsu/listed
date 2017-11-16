class UsageController < ApplicationController
  def index
    set_meta_images_for_letter("L")
    @secret_url = params[:secret_url]
  end
end
