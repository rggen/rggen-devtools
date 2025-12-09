# frozen_string_literal: true

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
