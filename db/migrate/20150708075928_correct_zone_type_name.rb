class CorrectZoneTypeName < ActiveRecord::Migration
  def change
    Zone.find_each{|it|
#      provice -> province
#      captical -> capital
      it.zone_type = 'province' if it.zone_type == 'provice'
      it.zone_type = 'capital' if it.zone_type == 'captical'
    }
  end
end
