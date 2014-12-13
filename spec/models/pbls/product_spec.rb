require 'rails_helper'

describe Pbls::Product do

  it { expect(described_class.new).to respond_to :title }

end