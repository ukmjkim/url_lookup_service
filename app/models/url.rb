class Url < ApplicationRecord
  # validations
  validates_presence_of :url, :created_by
end
