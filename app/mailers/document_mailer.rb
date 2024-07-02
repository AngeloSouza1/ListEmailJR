class DocumentMailer < ApplicationMailer
  default from: 'validemaillistjr@gmail.com'
  def send_document(contact, document)
    @contact = contact
    attachments[document.original_filename] = document.read
    mail(to: @contact.email, subject: 'Aqui está o documento que você solicitou')
  end

end


