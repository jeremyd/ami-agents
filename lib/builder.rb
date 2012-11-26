require 'dcell'

class Builder
  include Celluloid
  def available
    puts "I'm available"
    return true
  end

  def create_image
    puts "Quack!"
  end
end

# This "builder" node is also the directory service.
Builder.supervise_as :builder
DCell.start :id => "node1", :addr => "tcp://0.0.0.0:4000", :directory => { :id => "node1", :addr => "tcp://127.0.0.1:4000" }

sleep
