# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
#

provides "install" 

action :create do

  package node['database']['ep'] do
    action :install
    notifies :install,"package[redis]" 
  end

  package node['database']['db'] do
    action :nothing
  end

  service node['database']['db'] do
    action [:enable, :start]
  end

  service node['database']['fw'] do
    action [:enable, :start]
  end

  bash "enabling firewall over port 6379" do
    code <<-EOH
      firewall-cmd --permanent --zone=public --add-port=6379/tcp 
      firewall-cmd  --reload
      cd /home
      touch a.txt
    EOH
    not_if { ::File.exist? '/home/a.txt' }
  end

end

