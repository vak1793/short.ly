class DuplicateError < StandardError
  attr_accessor :url, :message

  def initialize(other_url, other_message)
    url = other_url
    message = other_message
  end
end
