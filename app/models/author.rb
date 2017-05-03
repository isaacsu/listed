class Author < ApplicationRecord

  has_many :posts

  def listed_posts
    self.posts.where(:unlisted => false)
  end

end
