require 'rails_helper'

describe Pbls::Product do
  it { expect(described_class.new).to respond_to :title }
  it { expect(described_class.new).to  belong_to(:product_form) }
end