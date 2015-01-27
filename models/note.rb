class Note < ActiveRecord::Base
  validates_presence_of :content
  validates_presence_of :github_username
end