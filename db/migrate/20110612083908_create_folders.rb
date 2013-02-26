class CreateFolders < ActiveRecord::Migration
  def self.up
    # create_table :folders do |t|
    #   t.string :name
    #   t.string :slug  
    #   t.integer :parent_id
    #   t.integer :created_by
    #   t.integer :updated_by
    #   t.timestamps
    # end
  end

  def self.down
    drop_table :folders
    remove_column :assets, :folder_id
  end
end
