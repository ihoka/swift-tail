Trestle.resource(:airports) do
  menu do
    item :airports, icon: "fa fa-star"
  end

  scopes do
    scope :all, default: true
    scope :private_jet_capable, -> { Airport.private_jet_capable }
    scope :major_airports, -> { Airport.major_airports }
  end

  table do
    column :iata_code
    column :icao_code
    column :name
    column :country_code
    column :elevation_ft
    column :type
    column :private_jet_capable
  end

  # Customize the form fields shown on the new/edit views.
  #
  # form do |airport|
  #   text_field :name
  #
  #   row do
  #     col { datetime_field :updated_at }
  #     col { datetime_field :created_at }
  #   end
  # end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:airport).permit(:name, ...)
  # end
end
