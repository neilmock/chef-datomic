node.default["java"]["jdk_version"] = 7

include_recipe "java"
include_recipe "runit"

version = node["datomic"]["version"]
license_type = node["datomic"]["license_key"].empty? ? "free" : "pro"
license_email = node["datomic"]["license_email"]
license_download_key = node["datomic"]["license_download_key"]

package "unzip" do
  action :install
end

group node["datomic"]["username"] do
  action :create
end

user node["datomic"]["username"] do
  system true
  shell "/bin/false"
  gid node["datomic"]["username"]
end

directory node["datomic"]["data_dir"] do
  owner node["datomic"]["username"]
  group node["datomic"]["username"]
end

cache_path = Chef::Config[:file_cache_path]
basename = "datomic-#{license_type}-#{version}"
install_dir = "#{node["datomic"]["dir"]}-#{license_type}-#{version}"

bash "download-datomic" do
  cwd cache_path
  code <<-EOH
    wget --no-clobber #{Datomic.download_auth(license_email, license_download_key)} \
         #{Datomic.download_url(license_type, version)} -O #{basename}.zip
    chown #{node["datomic"]["username"]}:#{node["datomic"]["username"]} #{basename}.zip
  EOH
  not_if { ::File.exists?(::File.join(cache_path, "#{basename}.zip")) }
end

bash "install-datomic" do
  cwd cache_path
  code <<-EOH
    unzip #{basename} -d /opt
    chown -R #{node["datomic"]["username"]}:#{node["datomic"]["username"]} #{install_dir}
  EOH
  not_if { ::File.exists?("/opt/#{basename}") }
end

link node["datomic"]["dir"] do
  to install_dir
  owner node["datomic"]["username"]
  group node["datomic"]["username"]
end

template ::File.join(node["datomic"]["dir"], "bin/transactor") do
  mode "0775"
  source "transactor.erb"
end

template ::File.join(node["datomic"]["dir"], "config/transactor.properties") do
  mode "0644"
  source "transactor.properties.erb"
  variables(
    :protocol               => node["datomic"]["protocol"],
    :host                   => node["datomic"]["host"],
    :port                   => node["datomic"]["port"],
    :license_key            => node["datomic"]["license_key"],
    :riak_host              => node["datomic"]["riak_host"],
    :riak_port              => node["datomic"]["riak_port"],
    :riak_bucket            => node["datomic"]["riak_bucket"],
    :riak_interface         => node["datomic"]["riak_interface"],
    :sql_url                => node["datomic"]["sql_url"],
    :sql_user               => node["datomic"]["sql_user"],
    :sql_password           => node["datomic"]["sql_password"],
    :sql_driver_class       => node["datomic"]["sql_driver_class"],
    :memory_index_threshold => node["datomic"]["memory_index_threshold"],
    :memory_index_max       => node["datomic"]["memory_index_max"],
    :object_cache_max       => node["datomic"]["object_cache_max"],
    :encrypt_channel        => node["datomic"]["encrypt_channel"],
    :data_dir               => node["datomic"]["data_dir"],
    :log_dir                => node["datomic"]["log_dir"],
    :write_concurrency      => node["datomic"]["write_concurrency"],
    :read_concurrency       => node["datomic"]["read_concurrency"],
    :heartbeat_interval     => node["datomic"]["heartbeat_interval"]
  )
  notifies :restart, "service[datomic-transactor]", :delayed
end

ruby_block "configure-zookeeper-cluster-in-riak" do
  block do
    ip_address, port = Riak.extract_riak_ip_and_port(node["riak"]["config"]["riak_core"]["http"])

    Riak.configure_zookeeper_cluster(
      ip_address,
      port,
      node["datomic"]["riak_bucket"],
      [ "#{node["zookeeper"]["host"]}:#{node["zookeeper"]["port"]}" ]
    )
  end
  notifies :restart, "service[datomic-transactor]", :delayed

  only_if do
    ip_address, port = Riak.extract_riak_ip_and_port(node["riak"]["config"]["riak_core"]["http"])

    node["datomic"]["protocol"] == "riak" && !Riak.zookeeper_cluster_configured?(
      ip_address,
      port,
      node["datomic"]["riak_bucket"]
    )
  end
end

runit_service "datomic-transactor" do
  action [ :enable, :start ]
  default_logger true
  owner node["datomic"]["username"]
  group node["datomic"]["username"]
  options ({
    :dir  => node["datomic"]["dir"],
    :user => node["datomic"]["username"]
  })
end
