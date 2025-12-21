# frozen_string_literal: true

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

  def not_have_parameter(*args, &body)
    layer, handler, attributes =
      if args.size == 3
        args[0..2]
      elsif args.size == 2
        [nil, *args[0..1]]
      else
        [nil, args[0], {}]
      end
    parameter = RgGen::SystemVerilog::Common::Utility::DataObject.new(:parameter, **attributes, &body)
    not_have_declaration(layer, :parameter, parameter.declaration).and not_have_identifier(handler, parameter.identifier)
  end

  before(:all) do
    @sv_rtl_factory ||= []
  end
end
