require 'pusher'

Pusher.app_id = ENV['PUSHER_ID']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

class ContactsController < ApplicationController
  respond_to :json

  def index
    respond_with Contact.all(order: "LOWER(last_name)")
  end

  def show
    respond_with Contact.find(params[:id])
  end

  def create
    Pusher['contact-channel'].trigger('change', {:message => 'hello world'})
    respond_with Contact.create(params[:contact]) 
  end

  def update
    Pusher['contact-channel'].trigger('change', {:message => 'hello world'})
    respond_with Contact.update(params[:id], params[:contact])
  end

  def destroy
    Pusher['contact-channel'].trigger('change', {:contact_id => params[:id]})
    respond_with Contact.destroy(params[:id])
  end
end
