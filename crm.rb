

require_relative 'rolodex'
require "pry"

require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact

  include DataMapper::Resource

  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :email, String
  property :note, String


DataMapper.finalize
DataMapper.auto_upgrade!

  attr_accessor :id, :first_name, :last_name, :email, :note

  def initialize(first_name, last_name, email, note)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @note = note
  end
end

$rolodex = Rolodex.new
$rolodex.add_contact(Contact.new("Yehuda", "Katz", "yehuda@example.com", "Developer"))
$rolodex.add_contact(Contact.new("Mark", "Zuckerberg", "mark@facebook.com", "CEO"))
$rolodex.add_contact(Contact.new("Sergey", "Brin", "sergey@google.com", "Co-Foun"))

contact=$rolodex.find(1000)

get '/' do
  @crm_app_name = "My CRM"
  erb :index
end

get '/contacts' do 
@contacts=Contact.all
  erb :contacts
end

get '/contacts/new' do
  erb :new_contact
end

post '/contacts' do
  
  contact=Contact.create(
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :notes => params[:notes])

  redirect to ('/contacts')
end

get '/contacts/:id' do
  @contact = Contact.get(params[:id].to_i)
  if @contact
  erb :show_contact
  else 
    raise Sinatra::NotFound
  end 
end

get '/contacts/:id/edit' do
  @contact = Contact.get(params[:id].to_i)
  if @contact
  erb :edit_contact
  else 
    raise Sinatra::NotFound
  end 
end



put '/contacts/:id' do
    @contact = Contact.get(params[:id].to_i)
  
  if @contact
    @contact.first_name= params[:first_name]
    @contact.last_name= params[:last_name]
    @contact.email= params[:email]
    @contact.notes= params[:notes]

  redirect to ("/contacts")
  else 
    raise Sinatra::NotFound
  end 
end

post '/contacts' do
 @contact=Contact.find(params[:id].to_i)

end

get "/contacts/delete" do
  erb :show_contact
end

delete "contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
    $rolodex.remove_contact(@contact)
    redirect to ("/contacts")

  else
    raise Sinatra::NotFound
  end

end




