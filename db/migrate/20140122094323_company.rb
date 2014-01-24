class Company < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string     :name
      t.string     :manager
      t.string     :cell_phone
      t.string     :telphone
      t.string     :address
      t.string     :province
      t.string     :city

      t.timestamps
    end
  end
end
