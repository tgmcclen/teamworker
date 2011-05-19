require File.dirname(__FILE__) + '/../spec_helper'

describe Absence do
  it "should be valid" do
    Absence.new.should be_valid
  end
end
