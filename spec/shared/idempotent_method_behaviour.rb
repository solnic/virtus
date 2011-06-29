shared_examples_for 'an idempotent method' do
  it 'is idempotent' do
    should equal(instance_eval(&self.class.subject))
  end
end
