class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action {
    if(session[:subscriber_id])
      @subscriber = Subscriber.find_by_id(session[:subscriber_id])
    end

    if params[:secret]
      author_id = params[:author_id] || params[:id]
      if author_id
        author = Author.find(author_id)
        if params[:secret] == author.secret
          @author = author
        end
      end
    end
  }

  def set_meta_images_for_author(author)
    return if author == nil
    first_letter = author.title[0].capitalize
    if first_letter == "@" && author.title.length > 1
      first_letter = author.title[1].capitalize
    end
    set_meta_images_for_letter(first_letter)
  end

  def set_meta_images_for_letter(first_letter)
    @meta_image = "https://s3.amazonaws.com/sn-listed/letters/big/#{first_letter}.png"
    @fav_icon = "https://s3.amazonaws.com/sn-listed/letters/fav/#{first_letter}.png"
  end


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
