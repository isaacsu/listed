class SubscriptionsController < ApplicationController

  def confirm
    @subscription = Subscription.find_by_token(params[:t])
    if @subscription
      @subscription.verified = true
      @subscription.token = nil
      @subscription.save

      if @subscription.author.email
        SubscriptionMailer.new_subscription(@subscription).deliver_later
      end
      
      redirect_to author_path(@subscription.author)
    else
      @error = true
    end
  end

end
