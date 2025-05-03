AuthJwtGo.configure do |config|
  config.secret_key_api = '1234567890'
  config.secret_key_jwt = '1234567890'
  # config.algorithm = 'HS256' # is optional by default 'HS256'
  # config.class_name_model = 'User' # is optional, if not send it creates a user object based on the payload
  # config.model_primary_key = 'id' # is optional by default 'id'
  # config.payload_primary_key = 'user_id' # is optional by default 'id'
end
