class AddStatusToWord < ActiveRecord::Migration
  def self.up
    add_column :words, :status, :int
  end

  def self.down
    remove_column :words, :status
  end
end
