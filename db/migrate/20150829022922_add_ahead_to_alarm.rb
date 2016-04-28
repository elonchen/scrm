class AddAheadToAlarm < ActiveRecord::Migration
  def change
    add_column :alarms, :ahead, :datetime unless column_exists? :alarms, :ahead
    Alarm.find_each do |it|
      it.update_column(:ahead, it.time-1.days)
    end
  end
end
