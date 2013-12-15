include_recipe "java"
include_recipe "runit"

license_type  = (node["datomic"]["license_key"].empty? ? "free" : "pro")
version       = node["datomic"]["version"]

group node["datomic"]["username"] do
  action :create
end

user node["datomic"]["username"] do
  system true
  shell "/bin/false"
  gid node["datomic"]["username"]
end
end

remote_file ::File.join(Chef::Config[:file_cache_path], "datomic-#{license_type}-#{version}.zip") do
  source node["datomic"]["url"]
  owner node["datomic"]["username"]
  group node["datomic"]["username"]
  checksum node["datomic"]["checksum"]
  action :create_if_missing
end

bash "install-datomic" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    unzip datomic-#{license_type}-#{version}.zip -d /opt
    chown -R #{node["datomic"]["username"]}:#{node["datomic"]["username"]} #{node["datomic"]["dir"]}-#{license_type}-#{version}
  EOH
  not_if { ::File.exists?("/opt/datomic-#{license_type}-#{version}") }
end

link node["datomic"]["dir"] do
  to "#{node["datomic"]["dir"]}-#{license_type}-#{version}"
  owner node["datomic"]["username"]
  group node["datomic"]["username"]
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
    :memory_index_threshold => node["datomic"]["memory_index_threshold"],
    :memory_index_max       => node["datomic"]["memory_index_max"],
    :object_cache_max       => node["datomic"]["object_cache_max"],
    :write_concurrency      => node["datomic"]["write_concurrency"],
    :read_concurrency       => node["datomic"]["read_concurrency"]
  )
  notifies :restart, "service[datomic-transactor]", :delayed
end

ruby_block "configure-zookeeper-cluster-in-riak" do
  block do
    Riak.configure_zookeeper_cluster(
      node["riak"]["config"]["riak_core"]["http"].keys.first.gsub(/__string_/, ""),
      node["riak"]["config"]["riak_core"]["http"].values.last,
      node["datomic"]["riak_bucket"],
      [ "10.0.2.15:2181" ]
    )
  end
  notifies :restart, "service[datomic-transactor]", :delayed

  only_if do
    node["datomic"]["protocol"] == "riak" && !Riak.zookeeper_cluster_configured?(
      node["riak"]["config"]["riak_core"]["http"].keys.first.gsub(/__string_/, ""),
      node["riak"]["config"]["riak_core"]["http"].values.last,
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
