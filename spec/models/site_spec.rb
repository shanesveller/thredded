require 'spec_helper'

describe Site do
  
  it { should have_many(:messageboards) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:permission) }

end
