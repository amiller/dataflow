require "#{File.dirname(__FILE__)}/../dataflow"
require 'net/http'
require 'drb'

include Dataflow

class RPSServer
  include DRbUndumped
  declare :p1, :p2
  declare :m1, :m2
  attr_accessor :queue
  
  def initialize
    @queue = Queue.new << :p1 << :p2
  end
  
  def move(p, move)
    unify m1, move if p == :p1
    unify m2, move if p == :p2
  end
  
  def register(client)
    p = queue.pop
    puts "Player #{p}: #{client}"
    unify p1, client if p == :p1
    unify p2, client if p == :p2
    p
  end
  
  def run()
    p1.message("You are player 1. Please wait for player 2.")
    p2.message("You are player 2. The game has begun!")
    
    Thread.new { p1.message "Your move was: #{m1}" }
    Thread.new { p2.message "Your move was: #{m2}" }
  
    [p1, p2].each { |p| p.message "The results are in..." }
    [p1, p2].each { |p| p.message "P1:#{m1} P2:#{m2}" }
    [p1, p2].each { |p| p.message "Tie!" } if m1 == m2
    [p1, p2].each { |p| p.message "Player 1 Wins!" } if m1 == :paper and m2 == :rock
    [p1, p2].each { |p| p.message "Player 1 Wins!" } if m1 == :rock and m2 == :scissors
    [p1, p2].each { |p| p.message "Player 1 Wins!" } if m1 == :scissors and m2 == :paper
    [p1, p2].each { |p| p.message "Player 2 Wins!" } if m2 == :paper and m1 == :rock
    [p1, p2].each { |p| p.message "Player 2 Wins!" } if m2 == :rock and m1 == :scissors
    [p1, p2].each { |p| p.message "Player 2 Wins!" } if m2 == :scissors and m1 == :paper
  end
end
  
server = RPSServer.new
DRb.start_service('druby://10.0.1.2:8000', server)
puts "Started drb server..."
server.run
DRb.thread.join
