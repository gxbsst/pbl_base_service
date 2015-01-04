class CreatingWork

  def self.create(listener, params, options = {})
    new(listener, params, options).create
    self
  end

  attr_reader :listener, :group, :params, :options, :task
  def initialize(listener, params, options = {})
    @listener = listener
    @params = params
    @options = options
    @group = Groups::Group.find(params.fetch(:group_id)) rescue nil
    @task = Pbls::Task.find(params.fetch(:task_id)) rescue nil
  end

  def create
    self
  end
end

require 'rails_helper'

describe CreatingWork do
  let(:listener) { double.as_null_object }
  let(:task)  { create :pbl_task }

  describe '.create' do

    context 'assign user work' do
      it 'create user work' do
        params = {
            task_id: task.id
        }
        # CreatingWork(listener, )
      end
    end

    context 'assign group work' do

    end

  end
end