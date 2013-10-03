require 'spec_helper'

describe Virtus::Attribute, '.build' do
  subject { described_class.build(type, options.merge(:name => name)) }

  let(:name) { :test }
  let(:type) { String }
  let(:options) { {} }

  share_examples_for 'a valid attribute instance' do
    it { should be_instance_of(Virtus::Attribute) }

    it { should be_frozen }
  end

  context 'without options' do
    it_behaves_like 'a valid attribute instance'

    it { should be_coercible }
    it { should be_public_reader }
    it { should be_public_writer }
    it { should_not be_lazy }

    it 'sets up a coercer' do
      expect(subject.options[:coerce]).to be(true)
      expect(subject.coercer).to be_instance_of(Virtus::Attribute::Coercer)
    end
  end

  context 'when name is passed as a string' do
    let(:name) { 'something' }

    its(:name) { should be(:something) }
  end

  context 'when coercion is turned off in options' do
    let(:options) { {:coerce => false} }

    it_behaves_like 'a valid attribute instance'

    it { should_not be_coercible }
  end

  context 'when options specify reader visibility' do
    let(:options) { {:reader => :private} }

    it_behaves_like 'a valid attribute instance'

    it { should_not be_public_reader }
    it { should be_public_writer }
  end

  context 'when options specify writer visibility' do
    let(:options) { {:writer => :private} }

    it_behaves_like 'a valid attribute instance'

    it { should be_public_reader }
    it { should_not be_public_writer }
  end

  context 'when options specify lazy accessor' do
    let(:options) { {:lazy => true} }

    it_behaves_like 'a valid attribute instance'

    it { should be_lazy }
  end

  context 'when options specify strict mode' do
    let(:options) { {:strict => true} }

    it_behaves_like 'a valid attribute instance'

    it { should be_strict }
  end

  context 'when type is a string' do
    let(:type) { 'Integer' }

    it_behaves_like 'a valid attribute instance'

    its(:type) { should be(Axiom::Types::Integer) }
  end

  context 'when type is a symbol of an existing class constant' do
    let(:type) { :String }

    it_behaves_like 'a valid attribute instance'

    its(:type) { should be(Axiom::Types::String) }
  end

  context 'when type is an axiom type' do
    let(:type) { Axiom::Types::Integer }

    it_behaves_like 'a valid attribute instance'

    its(:type) { should be(type) }
  end

  context 'when custom attribute class exists for a given primitive' do
    let(:type) { Class.new }
    let(:attribute) { Class.new(Virtus::Attribute) }

    before do
      attribute.primitive(type)
    end

    it { should be_instance_of(attribute) }

    its(:type) { should be(Axiom::Types::Object) }
  end

  context 'when custom attribute class exists for a given array with member coercion defined' do
    let(:type) { Class.new(Array)[String] }
    let(:attribute) { Class.new(Virtus::Attribute) }

    before do
      attribute.primitive(type.class)
    end

    it { should be_instance_of(attribute) }

    its(:type) { should be < Axiom::Types::Collection }
  end

  context 'when custom collection-like attribute class exists for a given enumerable primitive' do
    let(:type) { Class.new { include Enumerable } }
    let(:attribute) { Class.new(Virtus::Attribute::Collection) }

    before do
      attribute.primitive(type)
    end

    it { should be_instance_of(attribute) }

    its(:type) { should be < Axiom::Types::Collection }
  end

  context 'when extension registered for attribute' do
    let(:type) { Class.new }
    let(:attribute) { Class.new(Virtus::Attribute) }
    let(:extension) do
      Module.new do
        def self.extend?(attribute)
          attribute.options.key?(:annotations)
        end

        def annotations
          options[:annotations]
        end
      end
    end

    before do
      attribute.primitive(type)
      attribute.register_extension(extension)
    end

    it { should_not be_respond_to(:annotations) }

    context 'when extension is applicable' do
      let(:options) { {annotations: {simple: {value: true}}} }

      it { should be_respond_to(:annotations) }
      its(:annotations) { should == {simple: {value: true}} }
    end
  end

  context 'when extensions registered for hierarchical attributes' do
    let(:attribute) { Class.new(Virtus::Attribute) }
    let(:descendant_attribute) { Class.new(attribute) }
    let(:extension) do
      Module.new do
        def self.extend?(*)
          true
        end
      end
    end
    let(:other_extension) do
      Module.new do
        def self.extend?(*)
          true
        end
      end
    end

    context 'when extension registered for base, then for descendant' do
      before do
        attribute.register_extension(extension)
        descendant_attribute.register_extension(other_extension)
      end

      it 'attribute should have extension' do
        attribute.extensions.to_a.should =~ [extension]
      end

      it 'descendant attribute should have both extension & other_extension' do
        descendant_attribute.extensions.to_a.should =~ [extension, other_extension]
      end
    end

    context 'when extension registered for descendant, then for base' do
      before do
        descendant_attribute.register_extension(other_extension)
        attribute.register_extension(extension)
      end

      it 'attribute should have extension' do
        attribute.extensions.to_a.should =~ [extension]
      end

      it 'descendant attribute should have both extension & other_extension' do
        descendant_attribute.extensions.to_a.should =~ [extension, other_extension]
      end
    end
  end
end
