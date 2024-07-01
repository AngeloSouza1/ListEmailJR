class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :authorize_contact_access, only: [:show, :edit, :update, :destroy]

  def index
    if current_user
      @contacts = current_user.contacts

      if @contacts.empty?
        redirect_to new_contact_path, notice: 'You don\'t have any contacts yet. Create one now!'
      end
    else
      redirect_to new_user_session_path, alert: 'You need to sign in or register before continuing.'
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
      redirect_to @contact, notice: 'Contact was successfully created.'
    else
      render :new
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: 'Contact was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_url, notice: 'Contact was successfully destroyed.'
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
