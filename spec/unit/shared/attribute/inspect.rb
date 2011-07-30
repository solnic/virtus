shared_examples_for 'Attribute#inspect' do
  subject { attribute.inspect }

  let(:attribute) { described_class.new(attribute_name) }

  it { should == "#<#{described_class.inspect} @name=#{attribute_name.inspect}>" }
end
