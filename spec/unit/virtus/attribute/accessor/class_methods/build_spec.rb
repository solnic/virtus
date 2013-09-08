require 'spec_helper'

describe Virtus::Attribute::Accessor, '.build' do
  subject { described_class.build(name, type, options) }

  let(:name) { :test }

  let(:type) {
    double('type',
         :reader_class   => reader_class,
         :writer_class   => writer_class,
         :reader_options => reader_options,
         :writer_options => writer_options
        )
  }

  let(:reader_class) { double('reader_class') }
  let(:writer_class) { double('writer_class') }

  let(:reader_options) { {} }
  let(:writer_options) { {} }

  let(:reader) { double('reader') }
  let(:writer) { double('writer') }

  let(:options) { {} }

  context "without options" do
    before do
      reader_class.should_receive(:new).with(name, :visibility => :public).and_return(reader)
      writer_class.should_receive(:new).with(name, :visibility => :public).and_return(writer)
    end

    it { should be_instance_of(described_class) }

    its(:reader) { should be(reader) }
    its(:writer) { should be(writer) }
  end

  context "with options" do
    let(:other_reader_class) { double('other_reader_class') }
    let(:other_writer_class) { double('other_writer_class') }

    let(:reader_options) { { :foo => :bar } }
    let(:writer_options) { { :bar => :foo } }

    let(:options) {
      { :reader_class => other_reader_class,
        :writer_class => other_writer_class,
        :reader       => :private,
        :writer       => :protected,
        :lazy         => true }
    }

    before do
      other_reader_class.should_receive(:new).with(name, :foo => :bar, :visibility => :private).and_return(reader)
      other_writer_class.should_receive(:new).with(name, :bar => :foo, :visibility => :protected).and_return(writer)
    end

    it { should be_instance_of(described_class::LazyAccessor) }

    its(:reader) { should be(reader) }
    its(:writer) { should be(writer) }
  end
end
