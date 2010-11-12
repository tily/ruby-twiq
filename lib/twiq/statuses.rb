Sequel::Model.plugin(:schema)
Sequel.sqlite(ENV['HOME'] + '/.twiq')

module Twiq
  class Statuses < Sequel::Model
    set_schema do
      primary_key :id
      column :user, :string
      column :text, :string
    end
    create_table! unless table_exists?
  end
end
