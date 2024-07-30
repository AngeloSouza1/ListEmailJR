class DocumentMailer < ApplicationMailer
  default from: 'validemaillistjr@gmail.com'

  def send_documents(contact, documents, text_email)
    @contact = contact
    @text_email = text_email

    # Anexa todos os documentos ao e-mail
    documents.each do |document|
      attachments[document.original_filename] = document.read
    end

    mail(to: @contact.email, subject: 'Meu currículo para sua apreciação') do |format|
      format.text { render plain: @text_email }
      format.html { render 'send_documents' }
    end
  end




  
end
