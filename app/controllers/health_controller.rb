class HealthController < ApplicationController
  skip_before_action :authorized_user

  # GET /health
  def index
    render(
      json: {
        platform: {
          name: Rails.configuration.application_name,
          version: ActiveRecord::Migrator.current_version,
          api_version: Rails.configuration.api_version
        }
      },
      status: :ok
    )
  end
end
