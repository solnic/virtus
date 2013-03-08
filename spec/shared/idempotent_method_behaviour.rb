shared_examples_for 'an idempotent method' do
  it 'is idempotent' do
    should equal(subject)
  end
end
