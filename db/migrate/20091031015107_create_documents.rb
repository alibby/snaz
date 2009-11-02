class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :name, :title, :author, :date, :keywords, :abstract
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
