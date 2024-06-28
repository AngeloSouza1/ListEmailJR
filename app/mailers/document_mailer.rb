class DocumentMailer < ApplicationMailer
  default from: 'testando@email.co'

  def send_document(contact, document)
    @contact = contact
    @document = document
    attachments[document.original_filename] = document.read
    mail(to: @contact.email, subject: 'Here is your document')
  end


  def test_email(email)
    mail(to: email, subject: 'Test Email', body: 'This is a test email.')
  end

end


