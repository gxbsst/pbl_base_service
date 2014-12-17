require 'rails_helper'

RSpec.describe Resource, :type => :model do
  it { expect(described_class.new).to belong_to(:owner) }
  it { expect(described_class.new).to respond_to(:owner_id) }
  it { expect(described_class.new).to respond_to(:owner_type) }
  it { expect(described_class.new).to respond_to(:size) }
  it { expect(described_class.new).to respond_to(:ext) }
  it { expect(described_class.new).to respond_to(:mime_type) }
  it { expect(described_class.new).to respond_to(:md5) }
  it { expect(described_class.new).to respond_to(:key) }
  it { expect(described_class.new).to respond_to(:exif) }
  it { expect(described_class.new).to respond_to(:image_info) }
  it { expect(described_class.new).to respond_to(:image_ave) }
  it { expect(described_class.new).to respond_to(:persistent_id) }
  it { expect(described_class.new).to respond_to(:avinfo) }


end
