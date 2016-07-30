class CreateCosts < ActiveRecord::Migration
  def self.up
    create_table :costs do |t|
      t.string :profile
      t.float :value
      t.datetime :time

      t.timestamps
    end
  end

  def self.down
    drop_table :costs
  end
end
