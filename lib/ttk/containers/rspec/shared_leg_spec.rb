
$: << File.expand_path(File.join(__dir__, "..", "..", "..")) # useful when this file is directly required by other gems
require "ttk/containers/quotes/quote/shared"
require_relative "shared_product_spec"

RSpec.shared_examples "leg interface - required methods position" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  include_examples "product interface - required methods", TTK::Containers::Product
  include_examples "quote interface - required methods equity", TTK::Containers::Quotes::Quote
end

RSpec.shared_examples "leg interface - required methods order" do |parent_module|
  parent_module::Interface.required_methods.each do |rm|
    it "conforms to the expected interface by responding to method #{rm}" do
      expect(container).to respond_to(rm)
    end
  end

  include_examples "product interface - required methods", TTK::Containers::Product
end
