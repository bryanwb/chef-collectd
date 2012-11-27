# Author:: Bryan W. Berry
# Copyright 2012 Apache 2.0

actions :install, :remove

attr_accessor :port, :user, :password, :tomcat, :template, :cookbook, :jvm_name

attribute :port, :kind_of => String, :default => "8999"
attribute :user, :kind_of => String, :default => ""
attribute :password, :kind_of => String, :default => ""
attribute :tomcat, :equal_to => [true, false], :default => false
attribute :template, :kind_of => String, :default => "generic_jmx.conf.erb"
attribute :cookbook, :kind_of => String, :default => "collectd"
attribute :jvm_name, :kind_of => String, :default => ""

def initialize(*args)
  super
  @action ||= :install
end

