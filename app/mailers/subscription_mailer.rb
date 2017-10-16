class SubscriptionMailer < ApplicationMailer

  def confirm_subscription(subscription)
    @author = subscription.author
    @author_url = "#{ENV['HOST']}/#{@author.handle}"
    @confirm_url = "#{ENV['HOST']}/subscriptions/#{subscription.id}/confirm?t=#{subscription.token}"
    mail(to: subscription.subscriber.email, subject: "Confirm your subscription to #{subscription.author.title} on Listed")
  end

  def new_post(post, subscriber)
    @post = post
    @post_url = "#{ENV['HOST']}#{post.path}"
    mail(to: subscriber.email, subject: "#{post.author.title} published a new post: #{post.title}")
  end

  def new_subscription(subscription)
    @author = subscription.author
    mail(to: subscription.author.email, subject: "New subscriber to #{subscription.author.title}")
  end

end
