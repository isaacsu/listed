class Author < ApplicationRecord

  has_many :posts

  def listed_posts(exclude_post)
    self.posts.where(:unlisted => false) - [exclude_post]
  end

end
