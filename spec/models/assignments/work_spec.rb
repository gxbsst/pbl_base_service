require 'rails_helper'

RSpec.describe Assignments::Work, :type => :model do

  describe '#state' do
    let(:work) { described_class.create }
    it { expect(described_class.new.state).to eq('undue') }

    it 'open' do
      work.do_open
      expect(work.state).to eq('opening')
    end

    it 'work' do
      work.do_open
      work.work
      expect(work.state).to eq('working')
    end

    it 'submit' do
      work.do_open
      work.work
      work.submit
      expect(work.state).to eq('submitted')
    end

    it 'rework' do
      work.do_open
      work.work
      work.submit
      work.work
      expect(work.state).to eq('working')
    end

    it 'evaluate' do
      work.do_open
      work.work
      work.submit
      work.evaluate
      expect(work.state).to eq('evaluated')
    end
  end
end
