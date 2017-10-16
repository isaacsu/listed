class Subscription < ApplicationRecord
  include Tokenable

  belongs_to :author
  belongs_to :subscriber
end
