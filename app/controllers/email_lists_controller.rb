class EmailListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email_list, only: [:show, :edit, :update, :destroy]
  before_action :authorize_email_list_access, only: [:show, :edit, :update, :destroy]

  def index
    @email_lists = current_user.email_lists

    if @email_lists.blank?
      redirect_to new_email_list_path, notice: 'You don\'t have any email lists yet. Create one now!'
    end
  end

  def show
  end

  def new
    @email_list = current_user.email_lists.build
    @contacts = current_user.contacts
  end

  def edit
    @contacts = current_user.contacts
  end

  def create
    @email_list = current_user.email_lists.build(email_list_params)
    @contacts = current_user.contacts

    if @email_list.save
      redirect_to email_lists_path, notice: 'Email list was successfully created.'
    else
      render :new
    end
  end

  def update
    @contacts = current_user.contacts
    if @email_list.update(email_list_params)
      redirect_to email_lists_path, notice: 'Email list was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @email_list.destroy
    redirect_to email_lists_url, notice: 'Email list was successfully destroyed.'
  end

  def send_document
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
    @email_list = current_user.email_lists.find(params[:id])
  end

  def email_list_params
    params.require(:email_list).permit(:name, contact_ids: [])
  end

  def authorize_email_list_access
    redirect_to root_path, alert: 'Access denied.' unless current_user.email_lists.include?(@email_list)
  end
end
