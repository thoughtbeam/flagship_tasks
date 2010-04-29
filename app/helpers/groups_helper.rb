module GroupsHelper
  # Links the user to the given group as an owner.
  def make_owner_link(group, user)
    "Make Owner"
    #link_to 'Make Owner', GroupUser.find_all_by_user_id_and_group_id(user.id, group.id), :action=>make_owner
  end

  # Links the user to the given group as an ordinary member.
  def make_demote_link(group, user)
    "Make regular member"
  end

  # Unlinks the user from the given group.
  def make_remove_link(group, user)
    "Remove from Group"
  end
end
