class Commit < ActiveRecord::Base
  belongs_to :author
  belongs_to :push
  has_many :commit_files
end
