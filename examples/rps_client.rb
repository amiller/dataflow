require 'drb'
require 'thread'
require "#{File.dirname(__FILE__)}/../dataflow"

include Dataflow

class RPSClient
  include DRbUndumped
  attr_accessor :player
  attr_accessor :server
  
  def initialize
    @server = DRbObject.new(nil, 'druby://10.0.1.2:8000')
    @player = server.register(self)
  end
  
  def message(msg)
    puts "Message: #{msg}"
  end
  
  def rock
    server.move player, :rock
  end

  def paper
    server.move player, :paper
  end

  def scissors
    server.move player, :scissors
  end
end

DRb.start_service('druby://10.0.1.2:8001')
  #obj = DRbObject.new(nil, 'druby://10.0.1.7:8000')
@client = RPSClient.new
