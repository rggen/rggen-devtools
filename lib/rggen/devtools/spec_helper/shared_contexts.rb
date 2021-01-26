# frozen_string_literal: true

RSpec.shared_context 'clean-up builder' do
  after(:all) do
    RgGen.disable_all
  end
end

RSpec.shared_context 'configuration common' do
  class ConfigurationDummyLoader < RgGen::Core::Configuration::Loader
    class << self
      attr_accessor :values
      attr_accessor :data_block
    end

    def support?(_file)
      true
    end

    def load_file(_file, input_data, _valid_value_lists)
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

  def raise_configuration_error(message, position = nil)
    raise_rggen_error(RgGen::Core::Configuration::ConfigurationError, message, position)
  end

  def delete_configuration_factory
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
      attr_accessor :data_block
    end

    def support?(_file)
      true
    end

    def load_file(_file, input_data, _valid_value_lists)
      input_data.__send__(:build_by_block, &self.class.data_block)
    end
  end

  def build_register_map_factory(builder, enable_dummy_loader = true)
    factory = builder.build_factory(:input, :register_map)
    factory.loaders([RegisterMapDummyLoader.new([], {})]) if enable_dummy_loader
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

  def delete_register_map_factory
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

  before(:all) do
    RgGen::Core::RegisterMap::ComponentFactory.disable_no_children_error
  end

  after(:all) do
    RgGen::Core::RegisterMap::ComponentFactory.enable_no_children_error
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
    @sv_rtl_factory[0] ||= build_sv_rtl_factory(RgGen.builder)
    @sv_rtl_factory[0].create(configuration || default_configuration, register_map)
  end

  def delete_sv_rtl_factory
    @sv_rtl_factory.clear
  end

  def have_port(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    port = RgGen::SystemVerilog::Common::Utility::DataObject.new(:argument, **attributes, &body)
    have_declaration(layer, :port, port.declaration).and have_identifier(handler, port.identifier)
  end

  def not_have_port(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    port = RgGen::SystemVerilog::Common::Utility::DataObject.new(:argument, **attributes, &body)
    not_have_declaration(layer, :port, port.declaration).and not_have_identifier(handler)
  end

  def have_interface_port(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    port = RgGen::SystemVerilog::Common::Utility::InterfacePort.new(**attributes, &body)
    have_declaration(layer, :port, port.declaration).and have_identifier(handler, port.identifier)
  end

  def have_variable(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    variable = RgGen::SystemVerilog::Common::Utility::DataObject.new(:variable, **attributes, &body)
    have_declaration(layer, :variable, variable.declaration).and have_identifier(handler, variable.identifier)
  end

  def have_interface(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    interface = RgGen::SystemVerilog::Common::Utility::InterfaceInstance.new(**attributes, &body)
    have_declaration(layer, :variable, interface.declaration).and have_identifier(handler, interface.identifier)
  end

  def not_have_interface(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    interface = RgGen::SystemVerilog::Common::Utility::InterfaceInstance.new(**attributes, &body)
    not_have_declaration(layer, :variable, interface.declaration).and not_have_identifier(handler)
  end

  def have_parameter(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    parameter = RgGen::SystemVerilog::Common::Utility::DataObject.new(:parameter, **attributes, &body)
    have_declaration(layer, :parameter, parameter.declaration).and have_identifier(handler, parameter.identifier)
  end

  before(:all) do
    @sv_rtl_factory ||= []
  end
end

RSpec.shared_context 'sv ral common' do
  include_context 'configuration common'
  include_context 'register map common'

  def build_sv_ral_factory(builder)
    builder.build_factory(:output, :sv_ral)
  end

  def create_sv_ral(configuration = nil, &data_block)
    register_map = create_register_map(configuration) do
      register_block(&data_block)
    end
    @sv_ral_factory[0] ||= build_sv_ral_factory(RgGen.builder)
    @sv_ral_factory[0].create(configuration || default_configuration, register_map)
  end

  def delete_sv_ral_factory
    @sv_ral_factory.clear
  end

  def have_variable(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    variable = RgGen::SystemVerilog::Common::Utility::DataObject.new(:variable, **attributes, &body)
    have_declaration(layer, :variable, variable.declaration).and have_identifier(handler, variable.identifier)
  end

  def have_parameter(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    parameter = RgGen::SystemVerilog::Common::Utility::DataObject.new(:parameter, **attributes, &body)
    have_declaration(layer, :parameter, parameter.declaration).and have_identifier(handler, parameter.identifier)
  end

  before(:all) do
    @sv_ral_factory ||= []
  end
end

RSpec.shared_context 'markdown common' do
  include_context 'configuration common'
  include_context 'register map common'

  def build_markdown_factory(builder)
    builder.build_factory(:output, :markdown)
  end

  def create_markdown(configuraiton = nil, &data_block)
    register_map = create_register_map(configuraiton) do
      register_block(&data_block)
    end
    @markdown_factory[0] ||= build_markdown_factory(RgGen.builder)
    @markdown_factory[0].create(configuraiton || default_configuration, register_map)
  end

  def delete_markdown_factory
    @markdown_factory.clear
  end

  before(:all) do
    @markdown_factory ||= []
  end
end
