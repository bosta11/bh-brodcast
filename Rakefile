require 'sequel'

task :install_db do
	DB = Sequel.connect(ENV['DATABASE_URL'])
	DB.run("CREATE TABLE brodcasts (id SERIAL PRIMARY KEY, user_name TEXT, user_phone TEXT, category TEXT, details TEXT, active TEXT)")
	DB.run("CREATE TABLE messages (id SERIAL PRIMARY KEY, visitor_name TEXT, visitor_phone TEXT, visitor_email TEXT, visitor_message TEXT)")
	puts 'Done!'
end