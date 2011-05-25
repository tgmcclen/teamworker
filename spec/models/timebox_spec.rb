require File.dirname(__FILE__) + '/../spec_helper'

describe Timebox do
  it "should be valid" do
    Timebox.new.should be_valid
  end
end
