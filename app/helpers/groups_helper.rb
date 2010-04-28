module GroupsHelper
  def make_owner_link(group, user)
    "Make Owner"
    #link_to 'Make Owner', GroupUser.find_all_by_user_id_and_group_id(user.id, group.id), :action=>make_owner
  end

  def make_demote_link(group, user)
    "Make regular member"
  end

  def make_remove_link(group, user)
    "Remove from Group"
  end
end
