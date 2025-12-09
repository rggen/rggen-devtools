# frozen_string_literal: true

RSpec.shared_context 'configuration common' do
  class ConfigurationDummyLoader < RgGen::Core::Configuration::Loader
    class << self
      attr_accessor :values
      attr_accessor :data_block
    end

    def support?(_file)
      true
    end

    def load_file(input_data, _valid_value_lists, _file)
      self.class.values.size.positive? &&
        input_data.values(self.class.values)
      self.class.data_block &&
        input_data.__send__(:build_by_block, &self.class.data_block)
    end
  end

  def build_configuration_factory(builder, enable_dummy_loader = true)
    factory = builder.build_factory(:input, :configuration)
    factory.loaders([ConfigurationDummyLoader.new([], {})]) if enable_dummy_loader
    factory
  end

  def create_configuration(**values, &data_block)
    ConfigurationDummyLoader.values = values
    ConfigurationDummyLoader.data_block = data_block || proc {}
    @configuration_factory[0] ||= build_configuration_factory(RgGen.builder)
    @configuration_factory[0].create([''])
  end

  def delete_configuration_factory
    @configuration_factory.clear
  end

  before(:all) do
    @configuration_factory ||= []
  end
end
