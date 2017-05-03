class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action {
    author_id = params[:author_id] || params[:id]
    if author_id
      author = Author.find(author_id)
      if params[:secret] == author.secret
        @author = author
      end
    end
  }


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
