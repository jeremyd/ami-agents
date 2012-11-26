require 'dcell'
require 'trollop'
require 'highline/import'
require 'aws-sdk'
require 'pry'

unless ENV['AWS_SECRET_KEY'] && ENV['AWS_ACCESS_KEY']
  say "You must set the environment variables AWS_SECRET_KEY and AWS_ACCESS_KEY."
  exit 1
end
ENV['AWS_ACCESS_KEY_ID'] = ENV['AWS_ACCESS_KEY']
ENV['AWS_SECRET_ACCESS_KEY'] = ENV['AWS_SECRET_KEY']

ec2 = AWS::EC2.new()

choose do |region_menu|
  region_menu.prompt = "Which region is homebase?"
  region_menu.choices(*ec2.regions.map(&:name)) { |reg| @homebase_region = reg }
end
say "Using homebase region #{@homebase_region}."
ec2_homebase = ec2.regions[@homebase_region]
# See if homebase is already running based on tag search
homebase_sel = ec2.instances.select { |i| i if i.tags.include?("homebase") && [:running, :pending].include?(i.status) }
if homebase_sel.empty?
  say "Finding Archlinux Cloud World Domination Image in #{@homebase_region}"
  archlinux_images = ec2_homebase.images.with_owner("460511294004")
  select_ami = archlinux_images.select {|s| s.name =~ /pv.+2012.11.22.+x86_64.+ebs/}.first
  Trollop::die "FATAL: could not locate archlinux cloud world domination ami!" unless select_ami
  say "Launching Homebase."
  homebase = select_ami.run_instance( :security_groups => [ "default" ], 
                                         :availability_zone => "us-east-1c",
                                         :instance_type => "m1.small",
                                         :key_name => "jeremy_default")
  homebase.tag("homebase", :value => "true")
else
  say "Homebase already running."
  homebase = homebase_sel.first
end
say "Connecting to homebase agent"
pry

# TODO: homebase needs to be running with the directory service
# TODO: sshuttle to homebase

supervisor = DCell.start(:id => "dispatch", :addr => "tcp://0.0.0.0:4000")


# TODO: launch the image in the east if it's not UP.


# TODO: kick off image build
#node = DCell::Node["node1"]
#builder = node[:builder]
#while !builder.available
#  sleep 1
#end
#builder.create_image

# Shutdown cleanly?
#Celluloid::Actor.all.each do |actor|
#  actor.future(:terminate)
#end
#exit 0
