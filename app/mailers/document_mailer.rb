class DocumentMailer < ApplicationMailer
  default from: 'validemaillistjr@gmail.com'
  def send_document(contact, document)
    @contact = contact
    attachments[document.original_filename] = document.read
    mail(to: @contact.email, subject: 'Meu currículo para sua apreciação')
  end

end


