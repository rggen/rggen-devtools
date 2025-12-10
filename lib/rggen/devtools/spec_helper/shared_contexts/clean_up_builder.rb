# frozen_string_literal: true

RSpec.shared_context 'clean-up builder' do
  before(:all) do
    RgGen.disable_all
  end
end
