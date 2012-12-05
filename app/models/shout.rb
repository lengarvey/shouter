class Shout < ActiveRecord::Base
  attr_accessible :content, :user, :tag_string
  attr_accessor :tag_string

  validates :content, presence: true, length: { maximum: 140 }

  belongs_to :user

  has_and_belongs_to_many :tags

  before_save :process_tags
  before_save :escape_content
  before_save :check_for_usernames_in_content

  protected

  def escape_content
    self.content = ERB::Util.html_escape(content)
  end

  def check_for_usernames_in_content
    content.scan(/@(\w+)/).each do |user|
      # lookup user
      u = User.find_by_username(user[0])
      if u.present?
        # replace in the shout with the path to the user
        content.gsub(/@#{user[0]}/, "<a href='/users/#{u.id}'>@#{user[0]}")
      end
    end
  end

  def process_tags
    tags = self.tag_string.split(' ')
    return if tags.empty?

    tags.each do |tag|
      t = Tag.find_or_create_by_name(tag.downcase)
      self.tags << t
    end
  end
end
