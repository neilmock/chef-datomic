require File.expand_path("../support/helpers", __FILE__)

describe "datomic::default" do
  include Helpers::Datomic

  it "creates the base directory" do
    directory(node["datomic"]["dir"]).must_exist
  end

  it "creates the data directory" do
    directory(node["datomic"]["data_dir"]).must_exist
  end

  it "creates the transactor configuration file" do
    file("#{node["datomic"]["dir"]}/config/transactor.properties").must_exist
  end

  it "creates a daemon user" do
    user("datomic").must_exist
  end

  it "runs transactor as a daemon" do
    service("datomic-transactor").must_be_running
  end
end
