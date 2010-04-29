module GroupsHelper
  # Links the user to the given group as an owner.
  def make_owner_link(group, user)
    #Find the GroupUser record we'll need to modify.
    group_user = GroupUser.find_by_user_id_and_group_id(user.id, group.id)

    # Create a link. We'll POST to /groups/:group_id/group_users/:id/promote
    link_to 'Make Owner', 
      promote_group_group_user_path(group, group_user),
      :method => :post
  end

  # Links the user to the given group as an ordinary member.
  def make_demote_link(group, user)
    #Find the GroupUser record we'll need to modify.
    group_user = GroupUser.find_by_user_id_and_group_id(user.id, group.id)

    # Create a link. We'll POST to /groups/:group_id/group_users/:id/demote
    link_to 'Make regular member', 
      demote_group_group_user_path(group, group_user),
      :method => :post
  end

  # Unlinks the user from the given group.
  def make_remove_link(group, user)
    #Find the GroupUser record we'll need to modify.
    group_user = GroupUser.find_by_user_id_and_group_id(user.id, group.id)

    link_to "Remove from Group", [group, group_user], :method => :delete
  end
end
