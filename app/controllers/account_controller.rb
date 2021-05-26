# frozen_string_literal: true

# working with user accounts
class AccountController < ApplicationController
  require 'http'
  require 'securerandom'
  skip_before_action :authenticate_request

  before_action :user
  def verify_phone_number
    generate_verif
    Rails.cache.write(params[:phone_number], @verif, expires_in: 3.minutes)
    response = send_sms
    render json: if response.status.success?
                   { name: (user.name unless user.nil?) }
                 else
                   { error: 'Error while sending sms' }
                 end,
           status: response.status.success? ? 200 : 400
  end

  def login_register
    command = AuthenticateUser.call(params[:phone_number], params[:name], params[:verif])
    if command.success?
      render json: { jwt_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  private

  def send_sms
    HTTP.post('https://api.mobizon.ua/service/Message/SendSMSMessage', form: {
                recipient: params[:phone_number],
                text: "Your entry code: #{@verif}",
                apiKey: ENV['Mobizon__ApiKey']
              })
  end

  def user
    User.find_by_phone_number(params[:phone_number])
  end

  def generate_verif
    @verif = (SecureRandom.random_number(9e5) + 1e5).to_i
  end
end
