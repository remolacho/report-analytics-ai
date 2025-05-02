# frozen_string_literal: true

# :nodoc:
class BasePolicy
  attr_accessor :current_user

  # :nodoc:
  # @param [Object] current_user
  def initialize(current_user:)
    @current_user = current_user
  end

  # :nodoc:
  def loudly
    raise(ArgumentError) unless block_given?
    return true if yield

    raise(PolicyException)
  end
end
