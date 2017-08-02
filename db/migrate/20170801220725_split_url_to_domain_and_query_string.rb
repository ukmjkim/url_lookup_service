class SplitUrlToDomainAndQueryString < ActiveRecord::Migration[5.1]
  def change
    add_column :urlinfos, :domain_name, :string
    add_column :urlinfos, :query_string, :string
  end
end
