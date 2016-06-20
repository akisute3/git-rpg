class Repository < ActiveRecord::Base
  belongs_to :mst_git_service
  has_many :pushes
end
