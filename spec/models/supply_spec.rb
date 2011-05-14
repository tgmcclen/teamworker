require File.dirname(__FILE__) + '/../spec_helper'

describe Supply do
  it "should be valid" do
    Supply.new.should be_valid
  end
end
