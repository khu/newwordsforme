class CreateWord < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
          t.string :word
          t.string :translation
          t.timestamps
        end
  end
  
  def self.down
    drop_table :words
  end
end
