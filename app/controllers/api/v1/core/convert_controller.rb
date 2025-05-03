module Api
  module V1
    module Core
      class ConvertController < ApplicationController

        # POST /v1/core/convert/xlsx_to_dataset
        def index
            data = ::Core::Convert::XlsxToDataSet.data_set(params[:file])
            render json: {
              success: true,
              data: data
            }
        end
      end
    end
  end
end
