shared_examples_for 'an idempotent method' do
  it 'is idempotent' do
    is_expected.to equal(subject)
  end
end
