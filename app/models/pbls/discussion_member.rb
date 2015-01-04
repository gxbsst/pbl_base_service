class Pbls::DiscussionMember <  PgConnection
  belongs_to :user
  belongs_to :discussion, :class_name => 'Pbls::Discussion'
end
