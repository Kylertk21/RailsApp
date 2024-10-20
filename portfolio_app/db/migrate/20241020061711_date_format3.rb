class DateFormat3 < ActiveRecord::Migration[7.1]
  def change
    change_column :students, :grad_date, :date
  end
end
