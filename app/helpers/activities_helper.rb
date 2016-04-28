#encoding: utf-8
module ActivitiesHelper
  def changes_reason(activity)
    changes = activity.parameters[:changes] rescue nil
    reason = []
    if changes
      changes.each do |field, diff|
        field_name = activity.trackable_type.constantize.human_attribute_name(field)
        reason << "将<strong>#{field_name}</strong>由<span class='label label-info'>#{diff[0] rescue ''}</span>修改为<span class='label label-warning'>#{diff[1] rescue ''}</span>"
      end
    end
    reason
  end

  def update_state_reason(activity)
    changes = activity.parameters[:changes] rescue nil
    reason = []
    if changes
      changes.each do |field, diff|
        field_name = activity.recipient_type.constantize.human_attribute_name(field)
        if diff[0].present?
          reason << "将<strong>#{field_name}</strong>由<span class='label label-info'>#{diff[0] rescue ''}</span>修改为<span class='label label-warning'>#{diff[1] rescue ''}</span>"
        else
          reason << "增加<strong>#{field_name}</strong><span class='label label-success'>#{diff[1] rescue ''}</span>"
        end
      end
    end
    reason
  end
end
