class Subscription < ApplicationRecord
  include Tokenable

  belongs_to :author
  belongs_to :subscriber

  def self.send_weekly_emails
    subscriptions = Subscription.where(:frequency => "weekly", :verified => true, :unsubscribed => false)
    subscriptions.each do |sub|
      SubscriptionMailer.weekly_digest(sub).deliver_later
      sub.last_mailing = DateTime.now
      sub.save
    end
  end
end
