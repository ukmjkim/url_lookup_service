require 'rails_helper'

RSpec.describe Urlinfo, type: :model do
  # Validation tests
  # ensure columns url and created_by are present before saving
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:malware) }
  it { should validate_presence_of(:created_by) }
end
