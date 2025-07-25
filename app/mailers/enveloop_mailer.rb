class EnveloopMailer < ActionMailer::Base
   include Rails.application.routes.url_helpers

   def new_contact_email(recipient, comment)
      enveloop.send_message(
         template: "new-lead",
         to: recipient,
         from: "hello@flyswifttail.com",
         subject: subject,
         template_variables: {
           # Put form fields here
         }
      )
   end

   private

   def enveloop
      @enveloop ||= Enveloop::Client.new(api_key: Rails.application.credentials.dig(:enveloop, :ENVELOOP_LIVE_API_KEY))
   end
end
