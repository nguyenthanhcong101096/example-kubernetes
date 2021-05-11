class CreateCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :counts do |t|
      t.integer :view_count, default: 0
      t.string  :name,  default: "k8s"
      t.timestamps
    end
  end
end
