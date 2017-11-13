class Author < ApplicationRecord

  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions

  validates :username, uniqueness: true, :allow_nil => true, :allow_blank => true
  validates :email, uniqueness: true, :allow_nil => true, :allow_blank => true

  has_many :posts

  def listed_posts(exclude_post)
    (self.posts.where(:unlisted => false) - [exclude_post]).reverse
  end

  def title
    if self.display_name && self.display_name.length > 0
      return self.display_name
    elsif self.username && self.username.length > 0
      @title = "@#{self.username}"
    else
      @title = "#{self.id}"
    end
  end

  def handle
    "@#{self.username}"
  end

  def url
    "#{ENV['HOST']}/@#{self.username}"
  end

end
