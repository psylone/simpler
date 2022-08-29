# frozen_string_literal: true

# Simpler.application.db.create_table(:tests) do
#   primary_key :id
#   String :title, null: false
#   Integer :level, default: 0
# end
class Test < Sequel::Model
end
