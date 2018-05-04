require 'spec_helper'
require 'cypress_rails'

describe CypressRails do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end
