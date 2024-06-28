class ContactsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_contact, only: [:show, :edit, :update, :destroy]
  
    def index
      @contacts = Contact.all
    end
  
    def show
    end
  
    def new
      @contact = Contact.new
    end
  
    def edit
    end
  
    def create
      @contact = Contact.new(contact_params)
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
      @contact = Contact.find(params[:id])
      document = params[:document]
      DocumentMailer.send_document(@contact, document).deliver_now
      redirect_to @contact, notice: 'Document was successfully sent.'
    end
  
    private
  
    def set_contact
      @contact = Contact.find(params[:id])
    end
  
    def contact_params
      params.require(:contact).permit(:name, :email)
    end
  end
  