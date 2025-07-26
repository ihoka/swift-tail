class EnveloopMailer < ActionMailer::Base
   include Rails.application.routes.url_helpers

   def new_lead_email(lead, recipient = "contact@flyswifttail.com")
      enveloop.send_message(
         to: recipient,
         from: "contact@flyswifttail.com",
         subject: "New Lead Submission",
         html: <<~HTML
            <h1>New Lead Submission</h1>
            <p><strong>From:</strong> #{lead.from}</p>
            <p><strong>To:</strong> #{lead.to}</p>
            <p><strong>Email:</strong> #{lead.email}</p>
            <p><strong>Phone:</strong> #{lead.phone}</p>
            <p><strong>Created At:</strong> #{lead.created_at.strftime("%Y-%m-%d %H:%M:%S")}</p>
         HTML
      )
   end

   private

   def enveloop
      @enveloop ||= Enveloop::Client.new(api_key: api_key)
   end

   def api_key
      Rails.application.credentials.dig(Rails.env, :enveloop_api_key)
   end
end
