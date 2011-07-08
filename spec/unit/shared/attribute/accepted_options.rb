shared_examples_for 'Attribute.accepted_options' do
  specify { described_class.should respond_to(:accepted_options) }

  it "returns an array of accepted options" do
    described_class.accepted_options.should be_instance_of(Array)
  end

  it "includes base options" do
    described_class.accepted_options.should include(*Virtus::Attribute::OPTIONS)
  end
end
