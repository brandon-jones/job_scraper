class AddJobSearchTable < ActiveRecord::Migration
  def change
    create_table :job_search do |t|
      t.string      :name
      t.text        :description
      t.string      :image
      t.text        :options
      t.string      :homepage
      t.search_url  :string
      t.timestamps null: false
    end
    add_index :job_search, :name
  end

  

end
