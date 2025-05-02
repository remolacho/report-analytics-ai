module RequestHelpers
  extend ActiveSupport::Concern
  include AuthJwtGo

  private

  def encode_jwt(user)
    payload = {
      user_id: user.id,
      email: user.email,
      role: user.kind,
      exp: 1.days.from_now.to_i
    }

    encode_token(payload).dig(:jwt)
  end

  def setup_jwt(user)
    "Bearer #{encode_jwt(user)}"
  end

end
