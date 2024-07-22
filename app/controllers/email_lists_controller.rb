class EmailListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email_list, only: [:show, :edit, :update, :destroy, :send_document]
  before_action :authorize_email_list_access, only: [ :show, :edit, :update, :destroy]

  def index
    @email_lists = current_user.email_lists.order(updated_at: :desc, created_at: :desc)

    if @email_lists.empty?
      flash.now[:notice] = "Você ainda não tem nenhuma lista de e-mail. Crie uma agora!"
    end
  end

  def show
  end

  def new
    @email_list = EmailList.new
    @contacts = current_user.contacts

  end

  def edit
    @contacts = current_user.contacts.order(updated_at: :desc, created_at: :desc) # Ordena contatos por atualizado e criado

  end

  def create
    @email_list = current_user.email_lists.build(email_list_params)
    if @email_list.save
      redirect_to @email_list, notice: 'A lista de e-mail foi criada com sucesso.'
    else
      @contacts = current_user.contacts
      flash.now[:alert] = @email_list.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @email_list.update(email_list_params)
      redirect_to @email_list, notice: 'A lista de e-mail foi atualizada com sucesso.'
    else
      @contacts = current_user.contacts
      flash.now[:alert] = @email_list.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @email_list.destroy
    redirect_to email_lists_url, notice: 'A lista de e-mail foi destruída com sucesso.'
  end

  def send_document
    text_email_content = @email_list.text_email
    if params[:document].present?
      begin
        @email_list.contacts.each do |contact|
          document = ActionDispatch::Http::UploadedFile.new(
            tempfile: params[:document].tempfile,
            filename: params[:document].original_filename,
            content_type: params[:document].content_type
          )
          DocumentMailer.send_document(contact, document, text_email_content).deliver_now
        end
        redirect_to @email_list, notice: 'O documento foi enviado com sucesso para a lista de e-mail.'
      rescue StandardError => e
        redirect_to @email_list, alert: "Falha ao enviar documento: #{e.message}"
      end
    else
      redirect_to @email_list, alert: 'Nenhum arquivo de documento foi anexado.'
    end
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
