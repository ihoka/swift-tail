class EnveloopMailer < ActionMailer::Base
   include Rails.application.routes.url_helpers

   def new_lead_email(lead, recipient = "istvan.hoka@gmail.com")
      enveloop.send_message(
         template: "new-lead",
         to: recipient,
         from: "istvan.hoka@gmail.com",
         subject: "New Lead Submission",
         template_variables: {
            from: lead.from,
            to: lead.to,
            email: lead.email,
            phone: lead.phone,
            created_at: lead.created_at.strftime("%B %d, %Y at %I:%M %p")
         }
      )
   end

   private

   def enveloop
      @enveloop ||= Enveloop::Client.new(api_key: Rails.application.credentials.dig(:enveloop, :ENVELOOP_LIVE_API_KEY))
   end
end
