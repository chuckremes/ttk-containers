$: << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require_relative "shared_product_spec"
require_relative "shared_quote_spec"

RSpec.shared_examples "legs interface - required methods" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  # include_examples "product interface - required methods", TTK::Containers::Product
  # include_examples "quote interface - required methods", TTK::Containers::Quote
end
