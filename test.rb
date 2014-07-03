require 'sinatra'
require 'sequel'
enable :sessions
DB = Sequel.connect (ENV['DATABASE_URL'] || "sqlite://brdcast.dib")
Username="admin"
Password="a.1.1998.M.e"

set :public_folder, 'public'

get '/' do
	erb :index
end

get '/about' do
	erb :about
end

get '/callus' do
	erb :callus
end

post '/callus' do
	name = params[:username]
	phone = params[:phone]
	email = params[:email]
	message = params[:mes]
	DB[:messages].insert(:visitor_name => name , :visitor_phone => phone ,:visitor_email => email ,:visitor_message => message)
	redirect '/'
end

get '/add' do
	erb :add
end

post '/add' do
	name = params[:name]
	phone = params[:phone]
	cat = params[:cate]
	det = params[:mes]
	if name == ""
		name = "غير معروف"
	end
	if phone == ""
			phone = "غير معروف"
		end
	act = "لا"
	DB[:brodcasts].insert(:user_name => name ,:user_phone => phone ,:category => cat ,:details => det ,:active => act)
	redirect '/allbrd'
end

get '/allbrd' do
	@all = DB[:brodcasts].where(:active => "نعم").reverse_order(:id).all
	erb :allbrd
end

get '/news' do
	cat = "اخبار"
	@news = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :news
end

get '/islamic' do
	cat = "اسلاميات"
	@islamic = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :islamic
end

get '/ashaar' do
	cat = "اشعار"
	@ashaar = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :ashaar
end

get '/joke' do
	cat = "نكت"
	@jokes = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :jokes
end

get '/hizen' do
	cat = "حزن"
	@hizen = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :hizen
end

get '/night&morning' do
	cat = "صباح ومساء"
	@nightmorning = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :night_morning
end

get '/munasbat' do
	cat = "مناسبات"
	@munasbat = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :munasbat
end


get '/other' do
	cat = "منوع"
	@other = DB[:brodcasts].where(:category => cat , :active => "نعم").reverse_order(:id).all
	erb :other
end

before '/admin*' do
	if session[:is_login] != true
		redirect '/login'
	end
end

get '/logout' do
	session[:is_login] = false
	redirect '/'
end

get '/login' do
	erb :login
end

post '/login' do
	if Username == params[:username] and Password == params[:password]
			session[:is_login] = true
			redirect '/admin'
	else
		@error = true
		erb :login
	end 
end

get '/admin' do
	@last_brd = DB[:brodcasts].where(:active => "نعم").reverse_order(:id).first(5)
	@last_brd_no_act = DB[:brodcasts].where(:active => "لا").reverse_order(:id).first(5)
	@last_mes = DB[:messages].reverse_order(:id).first(5)
	erb :admin
end

get '/admin/brdcast/active/:id' do
	DB[:brodcasts].where(:id => params[:id]).update(:active => "نعم")
	redirect '/admin'
end

get '/admin/brdcast/del/:id' do
	DB[:brodcasts].where(:id => params[:id]).delete
	redirect '/admin'
end

get '/admin/brdcast/edit/:id' do
	@edit = DB[:brodcasts].where(:id => params[:id]).first
	erb :edit
end

post '/admin/brdcast/edit/:id' do
	name = params[:name]
	phone = params[:phone]
	cat = params[:cate]
	det = params[:mes]
	DB[:brodcasts].where(:id => params[:id]).update(:user_name => name , :user_phone => phone ,:category => cat ,:details => det)
	redirect '/admin'
end

get '/admin/messages/del/:id' do
	DB[:messages].where(:id => params[:id]).delete
	redirect '/admin'
end

get '/admin/brdcast/add' do
	erb :admin_add
end

post '/admin/brdcast/add' do
	name = params[:name]
	phone = params[:phone]
	cat = params[:cate]
	det = params[:mes]
	DB[:brodcasts].insert(:user_name => name ,:user_phone => phone ,:category => cat ,:details => det)
	redirect '/admin'
end


get '/admin/brdcast/setting' do
	@brdcast_edit = DB[:brodcasts].reverse_order(:id).all
	erb :admin_setting
end

get '/admin/brdcast/setting/del/:id' do
	DB[:brodcasts].where(:id => params[:id]).delete
	redirect '/admin/brdcast/setting'
end

get '/admin/brdcast/setting/edit/:id' do
	@edit = DB[:brodcasts].where(:id => params[:id]).first
	erb :edit
end

post '/admin/brdcast/setting/edit/:id' do
	name = params[:name]
	phone = params[:phone]
	cat = params[:cate]
	det = params[:mes]
	DB[:brodcasts].where(:id => params[:id]).update(:user_name => name , :user_phone => phone ,:category => cat ,:details => det)
	redirect '/admin/brdcast/setting'
end

get '/admin/brdcast/setting/activation' do
	@last_brd_no_act = DB[:brodcasts].where(:active => "لا").reverse_order(:id).all
	erb :brdcast_active
end

get '/admin/brdcast/setting/active/:id' do
	DB[:brodcasts].where(:id => params[:id]).update(:active => "نعم")
	redirect '/admin/brdcast/setting/activation'
end

get '/admin/messages' do
	@visitor_mes =DB[:messages].reverse_order(:id).all
	no_visitor_mes = DB[:messages].where(:id => "").first
	erb :admin_messages
end

get '/admin/messages/setting/del/:id' do
	DB[:messages].where(:id => params[:id]).delete
	redirect '/admin/messages'
end

not_found do
	"هذه الصفحة غير موجودة"
end
