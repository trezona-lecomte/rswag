class AuthTestsController < ApplicationController
  before_action :authenticate_bearer, only: :bearer

  # POST /auth-tests/basic
  def basic
    return head :unauthorized unless authenticate_basic

    head :no_content
  end

  # POST /auth-tests/api-key
  def api_key
    return head :unauthorized unless authenticate_api_key

    head :no_content
  end

  # POST /auth-tests/basic-and-api-key
  def basic_and_api_key
    return head :unauthorized unless authenticate_basic and authenticate_api_key

    head :no_content
  end

  # POST /auth-tests/bearer
  def bearer
    head :no_content
  end

  private

  def authenticate_basic
    authenticate_with_http_basic { |u, p| u == 'jsmith' && p == 'jspass' }
  end

  def authenticate_api_key
    params['api_key'] == 'foobar'
  end

  def authenticate_bearer
    authenticate_or_request_with_http_token do |token, _options|
      ActiveSupport::SecurityUtils.secure_compare(token, 'foobar')
    end
  end
end
