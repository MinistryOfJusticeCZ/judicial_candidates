class ContactsController < ApplicationController

  skip_before_action :require_login

  def index
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new
    @contact_message.attributes = contact_message_params
    if @contact_message.valid?
      ContactsMailer.contact_mail(@contact_message.mail, @contact_message.name, @contact_message.message).deliver_later
      redirect_to(contacts_path, notice: t('contact_form.notice_sent'))
    else
      render 'index'
    end
  end

  private
    def contact_message_params
      params.require(:contact_message).permit(:name, :mail, :message)
    end
end
