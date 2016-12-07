class CreateExamples < ActiveRecord::Migration
  def up
    create_table :examples do |t|
      t.belongs_to  :report, index: true
      t.string      :description,      :limit   => 255
      t.string      :full_description, :limit   => 1024
      t.integer     :status_id
      t.string      :file_path,        :limit   => 255
      t.integer     :line_number,                        :default => 0
      t.string      :pending_message,  :limit   => 255
      t.timestamps  :null => false
    end
  end

  def down
    drop_table :examples
  end
end
