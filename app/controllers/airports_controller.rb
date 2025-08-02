class AirportsController < ApplicationController
  def index
    query = params[:query]&.strip

    @airports = if query.present?
                  Airport.private_jet_capable.search(query)
                else
                  Airport.private_jet_capable
                end.limit(7)

    render partial: 'airport_options', locals: { airports: @airports }
  end
end
