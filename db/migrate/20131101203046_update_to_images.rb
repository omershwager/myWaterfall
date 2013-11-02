class UpdateToImages < ActiveRecord::Migration
  def change

	add_column :images, :asset_file_name, :string
	add_column :images, :asset_content_type, :string
	add_column :images, :asset_file_size, :integer
	add_column :images, :asset_updated_at, :datetime

  end
end


