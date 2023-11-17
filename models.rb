class User < ActiveRecord::Base
  has_many :sent_messages, class_name: 'Message', foreign_key: 'senderid'
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiverid'
end

class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', foreign_key: 'senderid'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiverid'
end