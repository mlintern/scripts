#!/usr/bin/env ruby

require 'CSV'
require 'ostruct'
require 'optparse'
require 'pp'

options = OpenStruct.new({
  :input_file => File.expand_path("servers.csv"),
  :verbose => false,
})

opts = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] run"
  opts.separator ""
  opts.on('-i', "--input-file INFILE", "File to use as input") do |infile|
    options.input_file = File.expand_path(infile);
  end
  opts.on('-v', '--[no-]verbose', "Run verbosely") do |verbose|
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

if !File.exists?(options.input_file)
  puts "File #{options.input_file} can't be found"
  puts opts
  exit 1
end

output_dir = File.expand_path("~/.dsh/group/")
if !File.directory?(output_dir) || !File.writable?(output_dir)
  puts "Directory #{output_dir} does not exist or is not writable"
  puts opts
  exit 1
end

rows = []
csv = File.open(options.input_file, 'r')
header = false
csv.each do |row|
  if !header
    header = true
    next
  end
  rows << row.chomp.split(',')
end

zones = {}
types = {'test' => {}, 'oldprod' => {}, 'newprod' => {}}
envs = {'test' => [], 'oldprod' => [], 'newprod' => []}

rows.each do |row|
  nick = row[0].gsub(' ', '')
  dnsname = row[1]
  pu_ip = row[2]
  pr_ip = row[3]
  zone = row[4]

  if zones[zone].nil?
    zones[zone] = []
  end
  zones[zone] << dnsname

  env = 'oldprod'
  if nick =~ /(tst|test)/
    envs['test'] << dnsname
    env = 'test'
  elsif nick =~ /prod/
    envs['newprod'] << dnsname
    env = 'newprod'
  else
    envs['oldprod'] << dnsname
  end

  type = nick.split('-')
  if type.length > 1
    type = type[0]
  else
    type = type[0].split('.')
    if type.length > 1
      type = type[0]
    else
      # Don't put this into types
      next
    end
  end
  if types[env][type].nil?
    types[env][type] = []
  end
  types[env][type] << dnsname
end

zones.each do |zone,hosts|
  next if hosts.length == 0
  file = File.new(File.expand_path("~/.dsh/group/compendium-zone-#{zone}"), 'w')
  hosts.each do |host|
    file << "#{host}\n"
  end
  file.close
end

envs.each do |env,hosts|
  next if hosts.length == 0
  file = File.new(File.expand_path("~/.dsh/group/compendium-env-#{env}"), 'w')
  hosts.each do |host|
    file << "#{host}\n"
  end
  file.close
end

types.each do |env,type_def|
  type_def.each do |type,hosts|
    next if hosts.length == 0
    file = File.new(File.expand_path("~/.dsh/group/compendium-#{env}-#{type}"), 'w')
    hosts.each do |host|
      file << "#{host}\n"
    end
    file.close
  end
end
