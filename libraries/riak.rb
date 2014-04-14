require "net/http"
require "uri"

module Riak
  def self.extract_riak_ip_and_port(riak_core_http)
    if riak_core_http.respond_to?(:keys)
      [ riak_core_http.keys.first.gsub(/__string_/, ""), riak_core_http.values.last ]
    else
      [ riak_core_http.first[1].gsub(/__string_/, ""), riak_core_http.first.last ]
    end
  end

  def self.configure_zookeeper_cluster(ipaddress, port, bucket, nodes)
    uri           = datomic_uri(ipaddress, port, bucket)
    request       = Net::HTTP::Put.new(uri.request_uri, "Content-Type" => "text/plain; charset=utf-8")
    request.body  = nodes.join(",")
    response      = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(request) }

    response.code == "204"
  end

  def self.zookeeper_cluster_configured?(ipaddress, port, bucket)
    uri           = datomic_uri(ipaddress, port, bucket)
    request       = Net::HTTP::Head.new(uri.request_uri)
    response      = Net::HTTP.new(uri.host, uri.port).start { |http| http.request(request) }

    response.code != "404"
  end

  private

  def self.datomic_uri(ipaddress, port, bucket)
    URI.parse("http://#{ipaddress}:#{port}/buckets/#{bucket}/keys/config%5Czookeeper?dw=2")
  end
end
