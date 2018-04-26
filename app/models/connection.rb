class Connection < ApplicationRecord
  belongs_to :connector, foreign_key: "connector_id", class_name: "User"
  belongs_to :connectee, foreign_key: "connectee_id", class_name: "User"
end
