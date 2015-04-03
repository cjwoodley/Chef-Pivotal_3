#
# Cookbook Name:: ambari
# Recipe:: default
#
# Copyright (C) 2015 
#
# 
#
selinux_state "Disabled" do
  action :disabled
end

execute "Disable IPtables" do
  command "sudo /etc/init.d/iptables save && sudo /etc/init.d/iptables stop && sudo /sbin/chkconfig iptables off"
  creates "/tmp/iptables_disabled"
  action :run
end

directory '/opt/sources' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

%w(
    httpd
  ).each do |p|
  yum_package p do 
    action :install
  end
end



bash 'install_ambari' do
  action :run
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf AMBARI-1.7.1-87-centos6.tar
  EOH
end

bash 'install_PHD' do
  action :nothing
  user 'root'
  cwd '/opt/sources'
  code <<-EOH
    tar -xf PHD-3.0.0.0-249-centos6.tar
  EOH
end

hostsfile_entry '192.168.56.200' do
  hostname  ['phdambari.local.com','phdambari']
  action    :create_if_missing
end

hostsfile_entry '192.168.56.201' do
  hostname  ['phds01.local.com','phds01']
  action    :create_if_missing
end

hostsfile_entry '192.168.56.202' do
  hostname  ['phds02.local.com','phds02']
  action    :create_if_missing
end