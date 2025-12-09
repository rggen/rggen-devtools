# frozen_string_literal: true

RSpec.shared_context 'clean-up builder' do
  after(:all) do
    RgGen.enable_all
  end
end
