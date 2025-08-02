class AirportsController < ApplicationController
  def index
    query = params[:query]&.strip
    
    airports = if query.present?
                 Airport.search(query)
               else
                 Airport.all
               end
    
    render json: airports.limit(7).select(:id, :name, :iata_code, :icao_code, :city, :country)
  end
end