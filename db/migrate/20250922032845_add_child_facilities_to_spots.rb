class AddChildFacilitiesToSpots < ActiveRecord::Migration[8.0]
  def change
    add_column :spots, :child_chair, :boolean, default: false
    add_column :spots, :tatami_seat, :boolean, default: false
    add_column :spots, :child_tableware, :boolean, default: false
    add_column :spots, :bring_baby_food, :boolean, default: false
    add_column :spots, :stroller_ok, :boolean, default: false
    add_column :spots, :child_menu, :boolean, default: false
    add_column :spots, :parking, :boolean, default: false
    add_column :spots, :other_facility, :boolean, default: false
  end
end
