class SubscriptionsController < ApplicationController

  def confirm
    @subscription = Subscription.find_by_token(params[:t])
    if @subscription
      @subscription.verified = true
      @subscription.save

      if @subscription.author.email
        SubscriptionMailer.new_subscription(@subscription).deliver_later
      end

      redirect_to author_path(@subscription.author)
    else
      @error = true
    end
  end

  def unsubscribe
    @subscription = Subscription.find_by_token(params[:t])
    if @subscription
      @subscription.unsubscribed = true
      @subscription.save
    else
      @error = true
    end
  end

  def update_frequency
    @subscription = Subscription.find_by_token(params[:t])
    if @subscription
      @subscription.frequency = params[:f]
      @subscription.last_mailing = DateTime.now
      @subscription.save
    else
      @error = true
    end
  end

end
