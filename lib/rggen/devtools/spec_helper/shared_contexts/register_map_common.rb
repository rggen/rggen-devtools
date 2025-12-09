# frozen_string_literal: true

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

    def load_file(input_data, _valid_value_lists, _file)
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
    RgGen.enable(:register_block, :__dummy)
    RgGen.enable(:register_file, :__dummy)
    RgGen.enable(:register, :__dummy)
    RgGen.enable(:bit_field, :__dummy)
  end

  before(:all) do
    RgGen::Core::RegisterMap::ComponentFactory.disable_no_children_error
  end

  after(:all) do
    RgGen::Core::RegisterMap::ComponentFactory.enable_no_children_error
  end
end
