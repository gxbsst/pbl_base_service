class AddProvinceIdAndCityIdAndCountryIdAndDistrictIdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :province_id, :uuid
    add_column :schools, :city_id, :uuid
    add_column :schools, :country_id, :uuid
    add_column :schools, :district_id, :uuid

    add_index :schools, :province_id
    add_index :schools, :city_id
    add_index :schools, :country_id
    add_index :schools, :district_id
  end
end
