class CommunicationNote < Note
  validates :content, presence: true, length: {minimum: 20}
end