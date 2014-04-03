maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Installs and configures Datomic."
version           "0.1.0"
recipe            "datomic", "Installs and configures Datomic"
name              "datomic"

depends "java", "~> 1.20.0"
depends "riak", "~> 2.4.7"
depends "runit", "~> 1.5.10"
depends "zookeeper", "~> 0.1.0"

%w{ ubuntu rhel scientific redhat centos }.each do |os|
  supports os
end
