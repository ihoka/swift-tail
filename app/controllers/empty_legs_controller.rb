class EmptyLegsController < ApplicationController
  def near_me
  end

  def by_airport
    @airport = Airport.by_iata_code(params[:iata_code])

    unless @airport.present?
      redirect_to root_path, alert: "Airport not found"
    end
  end
end
