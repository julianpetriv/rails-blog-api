# frozen_string_literal: true

# command for authorizing api request
class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  def user
    @user ||= User.find(decoded_auth_token[:id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return @headers['Authorization'].split(' ').last if @headers['Authorization'].present?

    errors.add(:token, 'Missing token')
    nil
  end
end
