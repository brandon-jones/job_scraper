class AddJobSearchTable < ActiveRecord::Migration
  def change
    create_table :job_searches do |t|
      t.string      :name
      t.text        :description
      t.string      :image
      t.text        :options
      t.string      :homepage
      t.string      :search_url
      t.string      :type
      t.timestamps null: false
    end
    add_index :job_searches, :name
  end

end
