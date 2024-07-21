class DocumentMailer < ApplicationMailer
  default from: 'validemaillistjr@gmail.com'

  def send_document(contact, document, text_email)
    @contact = contact
    @text_email = text_email
    attachments[document.original_filename] = document.read
    mail(to: @contact.email, subject: 'Meu currículo para sua apreciação')
  end
end

