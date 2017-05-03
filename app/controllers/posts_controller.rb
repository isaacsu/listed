class PostsController < ApplicationController

  def show
    @post = Post.find_by_token(params[:post_token])
    @hide_header = true
    if !@post
      not_found
    end
  end

  def index
    posts = Post.where(:unlisted => false).all
    days = []
    posts.group_by{|x| x.created_at.strftime("%B %e, %Y")}.each do |day, posts|
      days.push({:day => day, :posts => posts.reverse})
    end
    @days = days
  end

  def create
    item_uuid = params[:item_uuid]
    post = Post.find_by_item_uuid(item_uuid)
    if post && post.author != @author
      return
    end

    if !post
      post = @author.posts.new(post_params)
    else
      post.update(post_params)
    end

    item = params[:items][0]
    content = item["content"]

    post.title = content["title"]
    post.text = content["text"]

    post.save
  end

  def post_params
    params.permit(:unlisted, :item_uuid)
  end

end
