# frozen_string_literal: true

RSpec.shared_context 'clean-up builder' do
  after(:all) do
    RgGen.disable_all
  end
end

RSpec.shared_context 'configuration common' do
  class ConfigurationDummyLoader < RgGen::Core::Configuration::Loader
    class << self
      def support?(_file)
        true
      end

      attr_accessor :values
      attr_accessor :data_block
    end

    def load_file(_file)
      if self.class.values.size.positive?
        input_data.values(self.class.values)
      end
      if self.class.data_block
        input_data.__send__(:build_by_block, self.class.data_block)
      end
    end
  end

  def build_configuration_factory(builder)
    factory = builder.build_factory(:input, :configuration)
    factory.loaders([ConfigurationDummyLoader])
    factory
  end

  def create_configuration(**values, &data_block)
    ConfigurationDummyLoader.values = values
    ConfigurationDummyLoader.data_block = data_block || proc {}
    @configuration_factory[0] ||= build_configuration_factory(RgGen.builder)
    @configuration_factory[0].create([''])
  end

  def raise_configuration_error(message, position = nil)
    raise_rggen_error(RgGen::Core::Configuration::ConfigurationError, message, position)
  end

  def delete_configuration_facotry
    @configuration_factory.clear
  end

  before(:all) do
    @configuration_factory ||= []
  end
end

RSpec.shared_context 'register map common' do
  include_context 'configuration common'

  let(:default_configuration) do
    create_configuration
  end

  class RegisterMapDummyLoader < RgGen::Core::RegisterMap::Loader
    class << self
      def support?(_file)
        true
      end

      attr_accessor :data_block
    end

    def load_file(_file)
      input_data.__send__(:build_by_block, self.class.data_block)
    end
  end

  def build_register_map_factory(builder)
    factory = builder.build_factory(:input, :register_map)
    factory.loaders([RegisterMapDummyLoader])
    factory
  end

  def create_register_map(configuration = nil, &data_block)
    RegisterMapDummyLoader.data_block = data_block || proc {}
    @register_map_factory[0] ||= build_register_map_factory(RgGen.builder)
    @register_map_factory[0].create(configuration || default_configuration, [''])
  end

  def raise_register_map_error(message = nil, position = nil)
    raise_rggen_error(RgGen::Core::RegisterMap::RegisterMapError, message, position)
  end

  def delete_register_map_facotry
    @register_map_factory.clear
  end

  def match_access(access)
    have_properties [
      [:readable?, [:read_write, :read_only].include?(access)],
      [:writable?, [:read_write, :write_only].include?(access)],
      [:read_only?, access == :read_only],
      [:write_only?, access == :write_only],
      [:reserved?, access == :reserved]
    ]
  end

  before(:all) do
    @register_map_factory ||= []
  end
end

RSpec.shared_context 'sv rtl common' do
  include_context 'configuration common'
  include_context 'register map common'

  def build_sv_rtl_factory(builder)
    builder.build_factory(:output, :sv_rtl)
  end

  def create_sv_rtl(configuration = nil, &data_block)
    register_map = create_register_map(configuration) do
      register_block(&data_block)
    end
    @sv_rtl_facotry[0] ||= build_sv_rtl_factory(RgGen.builder)
    @sv_rtl_facotry[0].create(configuration || default_configuration, register_map)
  end

  def delete_sv_rtl_factory
    @sv_rtl_facotry.clear
  end

  def have_port(domain, handler, **atributes, &body)
    port = RgGen::SystemVerilog::Utility::DataObject.new(:argument, **atributes, &body)
    have_declaration(domain, :port, port.declaration).and have_identifier(handler, port.identifier)
  end

  def have_interface(domain, handler, **atributes, &body)
    interface = RgGen::SystemVerilog::Utility::InterfaceInstance.new(**atributes, &body)
    have_declaration(domain, :variable, interface.declaration).and have_identifier(handler, interface.identifier)
  end

  before(:all) do
    @sv_rtl_facotry ||= []
  end
end
