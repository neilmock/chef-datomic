# datomic [![Build Status](https://secure.travis-ci.org/hectcastro/chef-datomic.png?branch=master)](http://travis-ci.org/hectcastro/chef-datomic)

## Description

Installs and configures Datomic.

## Requirements

### Platforms

* Ubuntu 12.04
* CentOS 6.5

### Cookbooks

* java
* riak
* runit
* zookeeper

## Attributes

* `node["datomic"]["dir"]` - Directory to install into.
* `node["datomic"]["data_dir"]` - Data directory.
* `node["datomic"]["log_dir"]` - Log directory.
* `node["datomic"]["version"]` - Version of Datomic to install.
* `node["datomic"]["license_key"]` - If using Datomic Pro, a license key is needed.
* `node["datomic"]["url"]` - URL to download Datomic.
* `node["datomic"]["checksum"]` - Checksum for the Datomic archive.
* `node["datomic"]["username"]` - System user for the Datomic services.
* `node["datomic"]["protocol"]` - Datomic protocol (`riak`)
* `node["datomic"]["host"]` - Address to bind the Datomic service.
* `node["datomic"]["port"]` - Port to run Datomic on.
* `node["datomic"]["riak_host"]` - Riak host.
* `node["datomic"]["riak_port"]` - Riak Protocol Buffers port.
* `node["datomic"]["riak_interface"]` - Riak interface (`protobuf`, `http`).
* `node["datomic"]["riak_bucket"]` - Riak bucket to store Datomic configuration.
* `node["datomic"]["memory_index_threshold"]` - Index memory threshold.
* `node["datomic"]["memory_index_max"]` - Index memory maximum.
* `node["datomic"]["object_cache_max"]` - Object cache maximum.
* `node["datomic"]["write_concurrency"]` - Write concurrency.
* `node["datomic"]["read_concurrency"]` - Read concurrency (`2x` write concurrency).

## Recipes

* `recipe[datomic]` will install Datomic.

## Usage

Currently only supports Riak as a storage service.
