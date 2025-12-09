# frozen_string_literal: true

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
