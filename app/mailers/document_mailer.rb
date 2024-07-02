class DocumentMailer < ApplicationMailer
  default from: 'validemaillistjr@gmail.com'

  # def send_document(contact, document)
  #   @contact = contact
  #   @document = document
  #   attachments[document.original_filename] = document.read
  #   mail(to: @contact.email, subject: 'Here is your document')
  # end


  def send_document(contact, document)
    @contact = contact
    attachments[document.original_filename] = document.read
    mail(to: @contact.email, subject: 'Here is the document you requested')
  end











end


