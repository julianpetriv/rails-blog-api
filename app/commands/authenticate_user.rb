# frozen_string_literal: true

# command for user authentication
class AuthenticateUser
  prepend SimpleCommand

  def initialize(phone_number, name, verif)
    @phone_number = phone_number
    @name = name
    @verif = verif
  end

  def call
    JsonWebToken.encode(id: user.id, name: user.name) if user
  end

  private

  def user
    user = User.find_by_phone_number(@phone_number)
    user.name = @name if user
    user ||= User.new(name: @name, phone_number: @phone_number)
    if Rails.cache.fetch(user.phone_number) && Rails.cache.fetch(user.phone_number) == @verif
      user.save
      return user
    end
    errors.add :user_authentication, 'invalid verification code'
    nil
  end
end
