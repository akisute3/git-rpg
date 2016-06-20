class CommitFile < ActiveRecord::Base
  belongs_to :commit
  belongs_to :mst_commit_operation
end
