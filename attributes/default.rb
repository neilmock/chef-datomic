default["datomic"]["dir"] = "/opt/datomic"
default["datomic"]["data_dir"] = "/var/lib/datomic-transactor"
default["datomic"]["log_dir"] = "/var/log/datomic-transactor"

default["datomic"]["version"] = "0.9.4699"
default["datomic"]["checksum"] = "c76148848c7a4c46b95157db2a15205e6b28e469b4a7df0bd659f9c180f3bbdf"

# Get license information from https://my.datomic.com/account
default["datomic"]["license_key"] = nil ;
default["datomic"]["license_email"] = nil # "your.name@email.com"
default["datomic"]["license_download_key"] = nil # "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
default["datomic"]["url"] = nil

default["datomic"]["username"] = "datomic"
default["datomic"]["protocol"] = "dev"
default["datomic"]["host"] = "127.0.0.1"
default["datomic"]["port"] = 4334

default["datomic"]["riak_host"] = nil
default["datomic"]["riak_port"] = nil
default["datomic"]["riak_interface"] = nil
default["datomic"]["riak_bucket"] = nil

default["datomic"]["memory_index_threshold"] = "32m"
default["datomic"]["memory_index_max"] = "128m"
default["datomic"]["object_cache_max"] = "128m"
default["datomic"]["encrypt_channel"] = true
default["datomic"]["write_concurrency"] = 4
default["datomic"]["read_concurrency"] = 8
default["datomic"]["heartbeat_interval"] = 5000
