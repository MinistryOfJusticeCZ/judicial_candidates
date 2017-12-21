class ContactsController < ApplicationController

  skip_before_action :require_login

  def index
  end

  def create
    attrs = contact_params
    ContactsMailer.contact_mail(contact_params[:mail], contact_params[:name], contact_params[:message]).deliver_later
    redirect_to(contacts_path, notice: t('contact_form.notice_sent'))
  end

  private
    def contact_params
      params.require(:contact).permit(:name, :mail, :message)
    end
end
