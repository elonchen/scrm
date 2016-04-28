module MembersHelper

  def role_name(member)
    if member.has_role? :admin
      I18n.t("role.admin")
    elsif member.has_role? :worker
      I18n.t("role.worker")
    end

  end
end
