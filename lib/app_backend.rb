require 'sinatra'
require 'active_record'
require 'pony'
require_relative 'recipient'
require_relative 'contact_mailer'

class AppBackend < Sinatra::Base

  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database:  'db/www.sqlite3.db'
  )

  configure do
    enable :logging
  end

  post '/newsletter' do
    recipient = Recipient.create(email: params[:email])
    recipient.send_pdf ? status(200) : status(400)
  end

  post '/contact' do
    client = ContactMailer.new(email: params[:email], message: params[:message], name: params[:name])
    client.send_mail ? status(200) : status(400)
  end
end
