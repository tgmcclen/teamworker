require File.dirname(__FILE__) + '/../spec_helper'

describe Team do
  it "should be valid" do
    Team.new.should be_valid
  end
end
