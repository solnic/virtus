require 'spec_helper'

describe Virtus, '.config' do
  it 'provides global configuration' do
    Virtus.config { |config| config.coerce = false }

    expect(Virtus.coerce).to be(false)

    Virtus.config { |config| config.coerce = true }

    expect(Virtus.coerce).to be(true)
  end
end
