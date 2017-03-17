node.default['main']['doc_root']="/var/www/html"

execute "apt-get update" 
	command "apt-get update"
end

apt_package "apache2"
	action :install
end

service "apache2" do
	action [ :enable, :start]
end

directory node['main']['doc_root'] do
	owner 'www-data'
	group 'www-data'
	mode '0644'
	action :create
end

cookbook_file "#{node['main']['doc_root']}/index.html" do
	source 'index.html'
	owner 'www-data'
	group 'www-data'
	action :create
end


template "/etc/apache2/sites-available/000-default.conf" do
	source "vhost.erb"
	variables({ :doc_root => node['main']['doc_root']})
	action:create
	notifies :restart, resources(:service => "apache2")
end