#!/usr/bin/env ruby

require 'rubygems'
require 'fog'
require 'pp'
require 'net/ssh'
require 'ostruct'
require 'optparse'
require 'thread'
require 'progressbar'

options = OpenStruct.new({
  :access_key => "03YQ5PHM24V9YXECSEG2",
  :output_file => File.expand_path("servers.csv"),
  :secret_key => "8h7ZmRZC47MieaAxhhhlNajMFkn7AQd3MqvomFOT",
  :ssh_key => File.expand_path("~/.ssh/compendium.rsa"),
  :verbose => false,
})
opts = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] run"
  opts.separator ""
  opts.on('-a', '--access-key ACCESSKEY', "Amazon access key. Defaults to #{options.access_key}") do |access_key|
    options.access_key = access_key;
  end
  opts.on('-k', "--key KEYFILE", "SSH Key to connect to hosts with. Defaults to #{options.ssh_key}") do |key|
    options.ssh_key = File.expand_path(key)
  end
  opts.on('-o', "--output-file OUTFILE", "File to output server list to. Defaults to #{options.output_file}") do |outfile|
    options.output_file = File.expand_path(outfile);
  end
  opts.on('-s', "--secret-key SECRETKEY", "Amazon secret key. Defaults to #{options.secret_key}") do |secret_key|
    options.secret_key = secret_key
  end
  opts.on('-v', '--[no-]verbose', "Run verbosely.") do |verbose|
    options.verbose = verbose
  end
end

if ARGV.last != 'run' then
  pp opts
  exit 1
end

if not opts.parse!(ARGV) then
  pp opts
  exit 1
end
verbose = options.verbose

if !File.exists?(options.ssh_key)
  puts "File #{options.ssh_key} does not exist"
  puts opts
  exit 1
else
  puts "File #{options.ssh_key} exists" if options.verbose
end

if File.exists?(options.output_file)
  if !File.writable?(options.output_file)
    puts "File #{options.output_file} is not writable"
    puts opts
    exit 1
  else
    puts "File #{options.output_file} will be written to" if options.verbose
  end
else
  if !File.writable?(File.dirname(options.output_file))
    puts "Directory #{File.dirname(options.output_file)} is not writable, can not create #{options.output_file}"
    puts opts
    exit 1
  else
    puts "File #{options.output_file} will be written to" if options.verbose
  end
end

connection = Fog::AWS::Compute.new(:aws_access_key_id => options.access_key, :aws_secret_access_key => options.secret_key)

begin
  instances = connection.describe_instances
rescue Exception => e
  puts "Invalid Access or Secret key specified, error was: #{e.message}"
  puts opts
  exit 1
end

puts "Got server instances from EC2"

hosts = []
instances.body['reservationSet'].each do |set|
  i = set['instancesSet'][0]
  o = OpenStruct.new(i)
  if o.instanceState['name'] == 'running' then
    o.availabilityZone = i['placement']['availabilityZone']
    hosts << o
  end
end

progressbar = ProgressBar.new("Host Connections", hosts.length, STDOUT)

threads = []
unknown = 1
puts "Connecting to hosts"
hosts.each do |host|
  threads << Thread.new(host) do
    puts "Connecting to #{host.dnsName}" if verbose
    begin
      Net::SSH.start(host.dnsName, 'root', :password => 'invalidpassword', :keys => options.key, :timeout => 30) do |ssh|
	puts "Connected to #{host.dnsName}" if verbose
	hostname = ssh.exec!("hostname").chomp
	if hostname =~ /Please login as.*/ then
	  raise Exception.new("On an EC2 instance that hasn't yet bootstrapped")
	end
	host.nickName = hostname
	puts "Got hostname #{hostname} for host #{host.dnsName}" if verbose
      end
    rescue Exception => e
      begin
	Net::SSH.start(host.dnsName, 'ec2-user', :password => 'invalidPassword', :keys => options.key, :timeout => 30) do |ssh|
	  puts "Connected to #{host.dnsName}" if verbose
	  hostname = ssh.exec!("hostname").chomp
	  host.nickName = hostname
	  puts "Got hostname #{hostname} for host #{host.dnsName}" if verbose
	end
      rescue Exception => e2
	host.nickName = "unknown-#{unknown}"
	unknown += 1
	puts "ERROR: Could not connect to #{host.dnsName}, #{e2}" if verbose
      end
    end
    progressbar.inc
  end # Thread.new
end # hosts.each
threads.each { |thread| thread.join }

progressbar.finish

def host_csv(host)
  name = host.nickName
  pr_ip = host.privateIpAddress
  zone = host.availabilityZone
  dnsname = host.dnsName
  pu_ip = host.ipAddress
  instance_id = host.instanceId
  "#{name},#{dnsname},#{pu_ip},#{pr_ip},#{zone},#{instance_id}\n"
end

def get_host_int(host)
  name = host.nickName

  if name =~ /.*\..*/ then
    name = name.split('.').first
  else
    return name
  end

  if name =~ /.*-\d.*/ then
    parts = name.split('-')
    if parts.length > 1
      return parts[1]
    else
      return parts[0]
    end
  else
    return name
  end
end

newfile = File.new options.output_file, 'w'
newfile << "HOSTNAME,DNSNAME,PUBLIC-IP,PRIVATE-IP,ZONE,INSTANCE-ID\n"
hosts.sort! do |a,b|
  get_host_int(a) <=> get_host_int(b)
end
hosts.each do |host|
  newfile << host_csv(host)
end
newfile.close
puts "Servers are in #{newfile.path}"
