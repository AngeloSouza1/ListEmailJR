class EmailListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email_list, only: [:show, :edit, :update, :destroy, :send_document]
  before_action :authorize_email_list_access, only: [ :show, :edit, :update, :destroy]

  def index
     @email_lists = current_user.email_lists.order(updated_at: :desc)
  end

  def show

  end

  def new
    @email_list = EmailList.new
    @contacts = current_user.contacts

  end

  def edit
    @email_list = EmailList.find(params[:id])
    @contacts = current_user.contacts
    @selected_contacts = @email_list.contacts
  end



  def create
    @email_list = current_user.email_lists.build(email_list_params)
    if @email_list.save
      respond_to do |format|
        format.html { redirect_to  @email_list }
        format.turbo_stream { redirect_to email_lists_path(created: true) }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("error-messages", partial: "email_lists/error_messages", locals: { email_list: @email_list }) }
      end
    end
  end



  def update
    if @email_list.update(email_list_params)
      redirect_to email_lists_path
    else
      @contacts = current_user.contacts.order(updated_at: :desc, created_at: :desc)
      render :edit
    end
  end


  def destroy
    @email_list.destroy
    redirect_to email_lists_url
  end

  def send_document
    text_email_content = @email_list.text_email
    if params[:documents].present? && params[:documents].is_a?(Array) # Verifica se há documentos enviados e se é um array
      begin
        # Coleta todos os documentos em um array
        documents = params[:documents].map do |document_file|
          next if document_file.blank? # Ignora arquivos vazios

          # Cria um novo arquivo a partir do upload
          ActionDispatch::Http::UploadedFile.new(
            tempfile: document_file.tempfile,
            filename: document_file.original_filename,
            content_type: document_file.content_type
          )
        end.compact # Remove nils do array

        # Envia o e-mail para cada contato com todos os documentos anexados
        @email_list.contacts.each do |contact|
          DocumentMailer.send_documents(contact, documents, text_email_content).deliver_now
        end

        flash[:notice] = "Sua lista de e-mails foi enviada com sucesso!"
      rescue StandardError => e
        flash[:alert] = "Falha ao enviar documentos: #{e.message}"
      end
    else
      flash[:alert] = "Nenhum documento foi enviado."
    end
    redirect_to @email_list
  end




  private

  def set_email_list
    @email_list = current_user.email_lists.find(params[:id])
  end

  def email_list_params
    params.require(:email_list).permit(:name, :document, :send_date, :text_email, contact_ids: [])
  end

  def authorize_email_list_access
    redirect_to root_path, alert: 'Acesso negado.' unless current_user.email_lists.include?(@email_list)
  end


end
