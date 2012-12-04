class PhonesController < ApplicationController
  respond_to :json

  def index
    @contact = Contact.find(params[:contact_id])
    respond_with @contact.phones.all
  end

  def show
    @contact = Contact.find(params[:contact_id])
    @phone = @contact.phones.find(params[:id])
    respond_with [@contact, @phone]
  end

  def create
    Pusher['phone-channel'].trigger('change', {:message => 'hello world'})
    @contact = Contact.find(params[:contact_id])
    @phone = @contact.phones.create(params[:phone])
    respond_with [@contact, @phone]
  end

  def update
    Pusher['phone-channel'].trigger('change', {:message => 'hello world'})
    @contact = Contact.find(params[:contact_id])
    respond_with @contact.phones.update(params[:id], params[:phone])
  end

  def destroy
    Pusher['phone-channel'].trigger('change', {:message => 'hello world'})
    @contact = Contact.find(params[:contact_id])
    respond_with @contact.phones.destroy(params[:id])
  end
end
