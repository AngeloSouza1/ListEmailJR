class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :authorize_contact_access, only: [:show, :edit, :update, :destroy]

  def index
    if current_user
      @contacts = current_user.contacts.order(updated_at: :desc, created_at: :desc)

      if @contacts.empty?
        redirect_to new_contact_path, notice: 'Você ainda não tem nenhum contato. Crie um agora!.'
      end
    else
      redirect_to new_user_session_path, alert: 'Você precisa fazer login ou registrar-se antes de continuar.'
    end
  end

  def show
  end

  def new
    @contact = current_user.contacts.build
  end

  def edit
  end


  def create
    @contact = current_user.contacts.build(contact_params)
    if @contact.save
      respond_to do |format|
        format.html { redirect_to @contact, notice: 'Contato criado com sucesso.' }
        format.turbo_stream { redirect_to @contact }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("error-messages", partial: "contacts/error_messages", locals: { contact: @contact }) }
      end
    end
  end




  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: 'Contato atualizado com sucesso.'
    else
      Rails.logger.debug "Errors on update contact: #{@contact.errors.full_messages.join(", ")}"
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_url, notice: 'Contato excluído com sucesso.'
  end

  def send_document
    @contact = current_user.contacts.find(params[:id])
    document = params[:document]
    if document.present?
      DocumentMailer.send_document(@contact, document).deliver_now
      redirect_to @contact, notice: 'Document was successfully sent to the contact.'
    else
      redirect_to @contact, alert: 'No document provided.'
    end
  end

  private

  def set_contact
    @contact = current_user.contacts.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email)
  end

  def authorize_contact_access
    redirect_to root_path, alert: 'Access denied.' unless current_user.contacts.include?(@contact)
  end
end
