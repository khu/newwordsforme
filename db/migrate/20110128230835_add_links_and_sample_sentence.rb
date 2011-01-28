class AddLinksAndSampleSentence < ActiveRecord::Migration
  def self.up
    add_column :words, :link, :string
    add_column :words, :sample, :string
  end

  def self.down
    remove_column :words, :links
    remove_column :words, :sample
  end

end
