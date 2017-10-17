class AuthorsController < ApplicationController

  before_action {
    if params[:id]
      @display_author = Author.find(params[:id])
    elsif request.path.include? "@"
      username = request.path.gsub("/@", "")
      @display_author = Author.find_by_username(username)
    end

    set_meta_images_for_author(@display_author)
  }

  def create
    @author = Author.new
    secret = EncryptionHelper.generate_random_key
    @author.secret = secret
    @author.save
    redirect_to_authenticated_usage(@author, secret)
  end

  def show
    if !@display_author
      not_found
    end

    @title = "#{@display_author.title}"
    @desc = @display_author.bio || "Via Standard Notes."
  end

  def subscribe
    email = params[:email]
    @subscriber = Subscriber.find_or_create_by(email: email)
    session[:subscriber_id] = @subscriber.id
    subscription = Subscription.new author: @display_author, subscriber: @subscriber
    subscription.save

    SubscriptionMailer.confirm_subscription(subscription).deliver_later

    flash[:subscription_success] = true
    redirect_back(fallback_location: author_url(@display_author))
  end

  def redirect_to_authenticated_usage(author, secret)
    @secret_url = CGI.escape("#{ENV['HOST']}/authors/#{author.id}/extension/?secret=#{secret}&type=sn")
    redirect_to "/usage/?secret_url=#{@secret_url}"
  end

  def extension
    if !@author
      render :json => {:error => "Unable to load extension."}
    end

    secret = params[:secret]
    item_uuid = params[:item_uuid]

    name = "Listed"
    supported_types = ["Note"]
    actions = []
    if item_uuid
      actions += [
        {
          :label => "Publish to Blog",
          :url => "#{ENV['HOST']}/authors/#{@author.id}/posts/?unlisted=false&secret=#{secret}&item_uuid=#{item_uuid}",
          :verb => "post",
          :context => "Item",
          :content_types => ["Note"],
          :access_type => "decrypted"
        },
        {
          :label => "Open Blog",
          :url => "#{ENV['HOST']}/authors/#{@author.id}",
          :verb => "show",
          :context => "Item",
          :content_types => ["Note"],
          :access_type => "decrypted"
        },
        {
          :label => "Publish to Private Link",
          :url => "#{ENV['HOST']}/authors/#{@author.id}/posts/?unlisted=true&secret=#{secret}&item_uuid=#{item_uuid}",
          :verb => "post",
          :context => "Item",
          :content_types => ["Note"],
          :access_type => "decrypted"
        }
      ]
    end

    post = Post.find_by_item_uuid(item_uuid)
    if post
      actions.push(
      {
        :label => "Open Private Link",
        :url => "#{ENV['HOST']}/#{post.token}",
        :verb => "show",
        :context => "Item",
        :content_types => ["Note"]
      })

      actions.push(
      {
        :label => "Unpublish",
        :url => "#{ENV['HOST']}/authors/#{@author.id}/posts/#{post.id}/unpublish?secret=#{secret}",
        :verb => "post",
        :context => "Item",
        :content_types => ["Note"]
      })
    end

    actions.push (
    {
      :label => "Settings",
      :url => "#{ENV['HOST']}/authors/#{@author.id}/settings?secret=#{secret}",
      :verb => "show",
      :context => "Item",
      :content_types => ["Note"]
    }
    )

    description = "Publishes to listed.standardnotes.org. Requires decrypted access to publishing note."
    render :json => {:name => name, :description => description, :supported_types => supported_types, :actions => actions}
  end

  def update
    @author.username = a_params[:username]
    @author.display_name = a_params[:display_name]
    @author.bio = a_params[:bio]
    @author.link = a_params[:link]
    @author.email = a_params[:email]
    if @author.save
      redirect_to "/@#{@author.username}"
    else
      redirect_to :back
    end
  end

  private

  def a_params
    params.require(:author).permit(:username, :display_name, :bio, :link, :email, :secret)
  end

end
