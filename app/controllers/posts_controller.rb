class PostsController < ApplicationController

  def show
    if params[:id]
      @post = Post.find(params[:id])
      if @post.unlisted == true
        not_found
        return
      end
    else
      @post = Post.find_by_token(params[:post_token])
    end

    @hide_header = true
    if !@post
      not_found
    end

    if !@post.unlisted
      @author_posts = @post.author.listed_posts(@post)
    end
  end

  def index
    posts = Post.where(:unlisted => false).all
    days = []
    posts.group_by{|x| x.created_at.strftime("%B %e, %Y")}.each do |day, posts|
      days.push({:day => day, :posts => posts.reverse})
    end
    @days = days.reverse
  end

  def create
    item_uuid = params[:item_uuid]
    post = Post.find_by_item_uuid(item_uuid)
    if post && post.author != @author
      return
    end

    if !post
      is_new = true
      post = @author.posts.new(post_params)
    else
      is_new = false
      post.update(post_params)
    end

    item = params[:items][0]
    content = item["content"]

    post.title = content["title"]
    post.text = content["text"]

    if params[:unlisted] == "true"
      post.unlisted = true
    else
      post.unlisted = false
    end

    post.save

    if is_new
      @author.subscriptions.each do |subscription|
        if subscription.verified == true
          SubscriptionMailer.new_post(post, subscription.subscriber).deliver_later
        end
      end
    end
  end

  def unpublish
    if !@author
      render :json => {:error => "Unable to load extension."}
      return
    end

    post = Post.find(params[:id])
    if post.author != @author
      render :json => {:error => "Unauthorized"}
      return
    end

    post.delete
  end

  def post_params
    params.permit(:item_uuid, :slug, :username)
  end

end
