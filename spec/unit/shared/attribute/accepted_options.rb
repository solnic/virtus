shared_examples_for 'Attribute.accepted_options' do
  it 'includes base options' do
    described_class.accepted_options.should include(*Virtus::Attribute::OPTIONS)
  end
end
