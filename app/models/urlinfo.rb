class Urlinfo < ApplicationRecord
  # validations
  validates_presence_of :url, :malware, :created_by, :domain_name
end
