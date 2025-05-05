module Api
  module V1
    module Core
      class ConvertController < ApplicationController

        # POST /v1/core/convert/xlsx_to_dataset
        def index
            df = ::Core::DataFrame::Builder.new.build(params[:file])
            meses = %w[ENERO FEBRERO MARZO ABRIL MAYO JUNIO JULIO AGOSTO SEPTIEMBRE OCTUBRE NOVIEMBRE DICIEMBRE]
            suma_meses = df.select(meses).sum
            df_totales = Polars::DataFrame.new({
              "mes" => meses,
              "total" => suma_meses.row(0)
            })
            render json: {
              success: true,
              vega: df_totales.plot("mes", "total", type: "pie")
            }
        end
      end
    end
  end
end
