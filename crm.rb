


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
  property :notes, String


def to_s
  [first_name, last_name].join(' ')
end
 
end
DataMapper.finalize
DataMapper.auto_upgrade!


get '/' do
  @crm_app_name = "My CRM"
  erb :index
end

get '/contacts' do 
@contacts=Contact.all
puts @contacts.map{|c| c.to_s}
  erb :contacts
end

get '/contacts/new' do
  erb :new_contact
end

post '/contacts' do
  puts params
  Contact.create({
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :notes => params[:notes]})

  redirect to ('/contacts')
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
    @contact.update({
  :first_name => params[:first_name],
  :last_name => params[:last_name],
  :email => params[:email],
  :notes => params[:notes]})

  redirect to ("/contacts")
  
    else 
    raise Sinatra::NotFound
    end
  end

get "/contacts/delete/:id" do
@contact=Contact.get(params[:id].to_i)

  erb :show_contact
end

delete "/contacts/:id" do
  @contact = Contact.get(params[:id].to_i)
  if @contact
   @contact.destroy 
    redirect to ("/contacts")

  else
    raise Sinatra::NotFound
  end

get '/contacts/:id' do
  @contact = Contact.get(params[:id].to_i)
  if @contact
  erb :show_contact
  else 
    raise Sinatra::NotFound
  end 
end



post '/contacts' do
 @contact=Contact.find(params[:id].to_i)

end



end




