require 'rails_helper'

RSpec.describe Assignments::Work, :type => :model do

  it { expect(described_class.new).to have_many(:scores)}
  it { expect(described_class.new).to respond_to(:submit_at)}

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

    it 'evaluating' do
      work.do_open
      work.work
      work.submit
      work.evaluating
      expect(work.state).to eq('evaluating')
    end

    it 'evaluate' do
      work.do_open
      work.work
      work.submit
      work.evaluate
      expect(work.state).to eq('evaluated')
    end

    it 'undue' do
      work.do_open
      work.work
      work.submit
      work.evaluate
      work.undue
      expect(work.state).to eq('undue')
    end
  end
end
