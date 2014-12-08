class ContactMailer

  def initialize(params = {})
    @email = params[:email]
    @message = params[:message]
    @name = params[:name] || ""
    @config = set_config
  end

  def send_mail
    set_config
    Pony.mail(@config) unless @name.blank?
  end

  private
  def set_config
     config = {
          charset: 'UTF-8', from: @email,
          to: 'biz@ragnarson.com',
          subject: "Ragnarson WWW - contact form - #{@name}",
          body: @message
     }

     development = {
          via: :smtp,
          :via_options => { :address => 'localhost', :port => '1025' }
     }

     config.merge(development) if ENV['RACK_ENV'] = 'development'
  end
end
