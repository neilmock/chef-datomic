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

Directories:

* `node["datomic"]["dir"]` - Directory to install into.
* `node["datomic"]["data_dir"]` - Data directory.
* `node["datomic"]["log_dir"]` - Log directory.

Download information:

* `node["datomic"]["version"]` - Version of Datomic to install.
* `node["datomic"]["checksum"]` - Checksum for the Datomic archive.
* `node["datomic"]["license_key"]` - If using Datomic Pro, a license key is needed.
* `node["datomic"]["license_email"]` - If using Datomic Pro, the email associated with your license.
* `node["datomic"]["license_download_key"]` - If using Datomic Pro, the download key. See https://my.datomic.com/account.
* `node["datomic"]["url"]` - URL to download Datomic. Constructed automatically unless you override it.

Basic Datomic configuration:

* `node["datomic"]["username"]` - System user for the Datomic services.
* `node["datomic"]["protocol"]` - Datomic protocol (`riak`)
* `node["datomic"]["host"]` - Address to bind the Datomic service.
* `node["datomic"]["port"]` - Port to run Datomic on.

Riak configuration:

* `node["datomic"]["riak_host"]` - Riak host.
* `node["datomic"]["riak_port"]` - Riak Protocol Buffers port.
* `node["datomic"]["riak_interface"]` - Riak interface (`protobuf`, `http`).
* `node["datomic"]["riak_bucket"]` - Riak bucket to store Datomic configuration.

More Datomic configuration:

* `node["datomic"]["memory_index_threshold"]` - Index memory threshold.
* `node["datomic"]["memory_index_max"]` - Index memory maximum.
* `node["datomic"]["object_cache_max"]` - Object cache maximum.
* `node["datomic"]["encrypt_channel"]` - Enable SSL between peers and transactor.
* `node["datomic"]["write_concurrency"]` - Write concurrency.
* `node["datomic"]["read_concurrency"]` - Read concurrency (`2x` write concurrency).
* `node["datomic"]["heartbeat_interval"]` - Transactor heartbeat interval.

## Recipes

* `recipe[datomic]` will install Datomic.

## Usage

Currently supports the 'mem', 'dev', and 'riak' protocols (see
`node["datomic"]["protocol"]`):
