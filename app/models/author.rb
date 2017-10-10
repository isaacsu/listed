class Author < ApplicationRecord

  validates :username, uniqueness: true

  has_many :posts

  def listed_posts(exclude_post)
    self.posts.where(:unlisted => false) - [exclude_post]
  end

  def title
    if self.display_name
      return self.display_name
    elsif self.username
      @title = "@#{self.username}"
    else
      @title = "#{self.id}"
    end
  end

end
