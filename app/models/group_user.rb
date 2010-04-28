# This class is the bridge between users and groups.
# Aside from a group_id and a user_id, there is one attribute:
# is_admin which is true for site administrators.
class GroupUser < ActiveRecord::Base
  # Associate with the two models we're joining.
  belongs_to :group
  belongs_to :user

  # Make sure we don't wind up with the same user in a group twice
  # (this is needless and might cause funny output)
  validates_uniqueness_of :user_id, :scope => :group_id,
    :message => "is already in that group"
end
