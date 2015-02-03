require 'rails_helper'

RSpec.describe Comment, :type => :model do
  let!(:comment) { Comment.create :comment => 'comment'}

  it { expect(Comment.first.created_at).to eq('.')}
end
