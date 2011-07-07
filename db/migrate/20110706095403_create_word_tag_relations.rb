class CreateWordTagRelations < ActiveRecord::Migration
  def self.up
    create_table :word_tag_relations do |t|
      t.references :word
      t.references :tag

      t.timestamps
    end
  end

  def self.down
    drop_table :word_tag_relations
  end
end
