class AirportsController < ApplicationController
  def index
    query = params[:query]&.strip
    
    @airports = if query.present?
                  Airport.search(query)
                else
                  Airport.all
                end.limit(7)
    
    render partial: 'airport_options', locals: { airports: @airports }
  end
end