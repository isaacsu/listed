class SubscriptionMailer < ApplicationMailer

  def confirm_subscription(subscription)
    @author = subscription.author
    @author_url = "#{ENV['HOST']}/#{@author.handle}"
    @confirm_url = "#{ENV['HOST']}/subscriptions/#{subscription.id}/confirm?t=#{subscription.token}"
    mail(to: subscription.subscriber.email, subject: "Confirm your subscription to #{subscription.author.title} on Listed")
  end

  def new_post(post, subscriber)
    @post = post
    subscription = subscriber.subscription_for_author(post.author)
    @unsubscribe_url = "#{ENV['HOST']}/subscriptions/#{subscription.id}/unsubscribe?t=#{subscription.token}"
    if subscription.frequency == "daily"
      @weekly_url = "#{ENV['HOST']}/subscriptions/#{subscription.id}/update_frequency?f=weekly&t=#{subscription.token}"
    end
    @post_url = "#{ENV['HOST']}#{post.path}"
    @rendered_text = post.rendered_text
    mail(to: subscriber.email, subject: "#{post.author.title} published a new post: #{post.title}", reply_to: post.author.email)
  end

  def new_subscription(subscription)
    @author = subscription.author
    mail(to: subscription.author.email, subject: "New subscriber to #{subscription.author.title}")
  end

  def weekly_digest(subscription)
    @author = subscription.author
    @posts = subscription.author.posts.where("created_at > ?", subscription.last_mailing)
    @unsubscribe_url = "#{ENV['HOST']}/subscriptions/#{subscription.id}/unsubscribe?t=#{subscription.token}"
    mail(to: subscription.subscriber.email, subject: "New posts from #{subscription.author.title}")
  end

end
