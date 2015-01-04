class Pbls::Discussion < PgConnection
  belongs_to :project
  validates :project, presence: true

  has_many :discussion_members, :class_name => 'Pbls::DiscussionMember'
  has_many :members, class_name: 'User', through: :discussion_members

  def member_ids
    discussion_members.collect(&:user_id)
  end
end
