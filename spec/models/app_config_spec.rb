require 'spec_helper'

describe AppConfig do
  subject { create(:app_config) }

  it { should validate_presence_of(:permission) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end
