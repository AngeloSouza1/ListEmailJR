class EmailListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email_list, only: [:show, :edit, :update, :destroy, :send_document]
  before_action :authorize_email_list_access, only: [:show, :edit, :update, :destroy]

  def index
    @email_lists = current_user.email_lists
    redirect_to new_email_list_path, notice: "You don't have any email lists yet. Create one now!" if @email_lists.empty?
  end

  def show; end

  def new
    @email_list = current_user.email_lists.build
  end

  def edit
    @contacts = current_user.contacts
  end

  def create
    @email_list = current_user.email_lists.build(email_list_params)
    if @email_list.save
      redirect_to @email_list, notice: 'Email list was successfully created.'
    else
      render :new
    end
  end

  def update
    if @email_list.update(email_list_params)
      redirect_to @email_list, notice: 'Email list was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @email_list.destroy
    redirect_to email_lists_url, notice: 'Email list was successfully destroyed.'
  end

  def send_document
    document = params[:document]
    if document.present? && document.content_type.in?(%w(application/pdf application/msword application/vnd.oasis.opendocument.text))
      email_list.contacts.each do |contact|
        DocumentMailer.send_document(contact, document).deliver_now
      end
      redirect_to email_list_path(email_list), notice: 'Document was successfully sent to the email list.'
    else
      redirect_to email_list_path(email_list), alert: 'Invalid document type. Please select a PDF, DOC, or ODT file.'
    end
  end

  private

  def set_email_list
    @email_list = current_user.email_lists.find(params[:id])
  end

  def email_list_params
    params.require(:email_list).permit(:name, :document, contact_ids: [])
  end

  def authorize_email_list_access
    redirect_to root_path, alert: 'Access denied.' unless current_user.email_lists.include?(@email_list)
  end
end
