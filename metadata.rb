maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Installs and configures Datomic."
version           "0.1.0"
recipe            "datomic", "Installs and configures Datomic"
name              "datomic"

%w{ java riak runit zookeeper }.each do |d|
  depends d
end

%w{ ubuntu rhel scientific redhat centos }.each do |os|
  supports os
end
