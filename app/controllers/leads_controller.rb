class LeadsController < ApplicationController
  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      EnveloopMailer.new_lead_email(@lead)
      redirect_to root_path, notice: "Thank you! We'll be in touch soon."
    else
      redirect_to root_path, alert: "Please fill in all required fields."
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:from, :to, :email, :phone)
  end
end
