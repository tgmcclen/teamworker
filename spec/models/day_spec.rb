require File.dirname(__FILE__) + '/../spec_helper'

describe Day do
  it "should be valid" do
    Day.new.should be_valid
  end
end
