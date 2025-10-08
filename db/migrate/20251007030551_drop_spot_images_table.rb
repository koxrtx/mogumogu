class DropSpotImagesTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :spot_images
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
