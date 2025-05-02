# frozen_string_literal: true

# :nodoc:
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from PolicyException, with: :forbidden
    rescue_from JWT::ExpiredSignature, with: :expired_signature
    rescue_from JWT::VerificationError, with: :without_authorization
    rescue_from JWT::DecodeError, with: :invalid_authorization
    rescue_from ArgumentError, with: :argument_error
    rescue_from RestClient::Exceptions::ReadTimeout, with: :timeout
    rescue_from RestClient::NotFound, with: :not_found_rest
    rescue_from RestClient::Forbidden, with: :locked
    rescue_from NoMethodError, with: :locked
  end

  # :nodoc:
  def not_found(exception)
    message = exception.message || 'Not Found'
    json_response(response: { success: false, message: message, object: exception.model, id: exception.id }, status: :not_found)
  end

  # :nodoc:
  def not_found_rest
    json_response(response: { success: false, message: 'Resource not found in API' }, status: :not_found)
  end

  # :nodoc:
  def forbidden
    json_response(response: { success: false, message: 'Forbidden' }, status: :forbidden)
  end

  # :nodoc:
  def expired_signature
    json_response(response: { success: false, message: 'Authentication Timeout' }, status: 419)
  end

  # :nodoc:
  def without_authorization
    json_response(response: { success: false, message: 'Missing Bearer Token' }, status: :unauthorized)
  end

  # :nodoc:
  def invalid_authorization
    json_response(response: { success: false, message: 'Invalid Bearer Token' }, status: :unauthorized)
  end

  # :nodoc:
  def locked(message)
    json_response(response: { success: false, message: (message || 'Unable to access to asked resources') }, status: :locked)
  end

  # :nodoc:
  def argument_error(invalid)
    json_response(response: { success: false, message: invalid.to_s }, status: :unprocessable_entity)
  end

  # :nodoc:
  def timeout(message)
    json_response(response: { success: false, message: message }, status: 408)
  end

  # :nodoc:
  def json_response(response:, status: :ok)
    Rails.logger.debug(response.inspect) if Rails.env.development?
    render(json: response, status: status)
  end
end
