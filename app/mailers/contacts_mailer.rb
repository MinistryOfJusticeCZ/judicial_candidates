class ContactsMailer < ApplicationMailer

  layout 'contacts_mailer'

  default to: EgovUtils::Settings['contact_mail'] || 'posta@msp.justice.cz'

  def contact_mail(mail, name, message)
    @name = name
    @message = message
    mail(from: "#{name} <#{mail}>", subject: t(:app_name))
  end

end
