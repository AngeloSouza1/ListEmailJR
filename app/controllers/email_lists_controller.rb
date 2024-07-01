class EmailListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email_list, only: [:show, :edit, :update, :destroy]
  before_action :authorize_email_list_access, only: [:show, :edit, :update, :destroy]

  def index
    # Busca todas as listas de e-mails pertencentes ao usuário atual
    @email_lists = current_user.email_lists

    # Se não houver listas de e-mails, redireciona para criar uma nova lista
    if @email_lists.empty?
      redirect_to new_email_list_path, notice: 'You don\'t have any email lists yet. Create one now!'
    end
  end


  def show
    # Mostra apenas a lista de e-mails se ela pertencer ao usuário atual
    # O before_action :authorize_email_list_access já garante isso
  end

  def new
    # Cria uma nova lista de e-mails associada ao usuário atual
    @email_list = current_user.email_lists.build
  end

  def edit
    # Edita apenas a lista de e-mails se ela pertencer ao usuário atual
    # O before_action :authorize_email_list_access já garante isso
  end

  def create
    # Cria uma nova lista de e-mails associada ao usuário atual
    @email_list = current_user.email_lists.build(email_list_params)

    if @email_list.save
      redirect_to @email_list, notice: 'Email list was successfully created.'
    else
      render :new
    end
  end


  def update
    # Atualiza a lista de e-mails se ela pertencer ao usuário atual
    if @email_list.update(email_list_params)
      redirect_to @email_list, notice: 'Email list was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # Remove a lista de e-mails se ela pertencer ao usuário atual
    @email_list.destroy
    redirect_to email_lists_url, notice: 'Email list was successfully destroyed.'
  end

  def send_document
    # Envio de documento para contatos da lista de e-mails do usuário atual
    email_list = current_user.email_lists.find(params[:id])
    document = params[:document]
    if document.present?
      email_list.contacts.each do |contact|
        DocumentMailer.send_document(contact, document).deliver_now
      end
      redirect_to email_list, notice: 'Document was successfully sent to the email list.'
    else
      redirect_to email_list, alert: 'No document provided.'
    end
  end

  private

  def set_email_list
    # Encontra a lista de e-mails apenas se ela pertencer ao usuário atual
    @email_list = current_user.email_lists.find(params[:id])
  end

  def email_list_params
    params.require(:email_list).permit(:name, contact_ids: [])
  end

  def authorize_email_list_access
    # Verifica se o usuário atual tem acesso à lista de e-mails solicitada
    redirect_to root_path, alert: 'Access denied.' unless current_user.email_lists.include?(@email_list)
  end
end
