class EmailListsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_email_list, only: [:show, :edit, :update, :destroy]
  
    def index
      @email_lists = EmailList.all
    end
  
    def show
      @email_list = EmailList.find(params[:id])
    end
  
    def new
      @email_list = EmailList.new
    end
  
    def edit
    end
  
    def create
      @email_list = EmailList.new(email_list_params)
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
      @email_list = EmailList.find(params[:id])
      document = params[:document]
      @email_list.contacts.each do |contact|
        DocumentMailer.send_document(contact, document).deliver_now
    
      end
      redirect_to @email_list, notice: 'Document was successfully sent to the email list.'
    end
  
    private
  
    def set_email_list
      @email_list = EmailList.find(params[:id])
    end
  
    def email_list_params
      params.require(:email_list).permit(:name, contact_ids: [])
    end
  end
  