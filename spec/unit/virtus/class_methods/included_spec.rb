require 'spec_helper'

describe Virtus, '.included' do
  context "with a class" do
    it "includes ClassInclusions" do
      klass = Class.new { include Virtus }
      expect(klass).to be < Virtus::ClassInclusions
    end
  end

  context "with a module" do
    it "extends with ModuleExtensions" do
      mod = Module.new { include Virtus }
      expect(mod).to be_kind_of(Virtus::ModuleExtensions)
    end
  end
end
