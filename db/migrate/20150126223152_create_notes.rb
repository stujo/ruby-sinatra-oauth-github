class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.boolean :complete
      t.text :content
      t.string :github_username
      t.string :github_repo
      t.timestamps :null => true
    end  
  end
end