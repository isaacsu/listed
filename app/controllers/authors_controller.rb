class AuthorsController < ApplicationController

  def create
    @author = Author.new
    secret = EncryptionHelper.generate_random_key
    @author.secret = secret
    @author.save
    redirect_to_authenticated_usage(@author, secret)
  end

  def show
    if params[:id]
      @author = Author.find(params[:id])
    else
      username = request.path.gsub("/@", "")
      @author = Author.find_by_username(username)
    end

    if !@author
      not_found
    end

    @title = "#{@author.title} — Listed"
    @desc = author.bio || "Via Standard Notes."

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
    if @author.save
      redirect_to "/@#{@author.username}"
    else
      redirect_to :back
    end
  end

  private

  def a_params
    params.require(:author).permit(:username, :display_name, :bio, :link, :secret)
  end

end
