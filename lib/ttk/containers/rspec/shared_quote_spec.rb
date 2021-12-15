
$: << File.expand_path(File.join(__dir__, '..', '..', '..')) # useful when this file is directly required by other gems
require 'ttk/containers/quotes/quote/shared'

RSpec.shared_examples "quote interface - required methods" do |parent_module|

  it 'conforms to the required interface' do
    parent_module::Interface.required_methods.each do |rm|
      expect(quote).to respond_to(rm)
    end
  end
end
