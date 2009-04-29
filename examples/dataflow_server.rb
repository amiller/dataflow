require "#{File.dirname(__FILE__)}/../dataflow"
require 'net/http'
require 'drb'

include Dataflow

class DataflowServer
  include DRbUndumped
  def spider(client, keyword)
    # Be gentle running this one
    Thread.abort_on_exception = true
    local do |stream, branding_occurences, number_of_mentions|
      unify stream, Array.new(10) { Dataflow::Variable.new }
      stream.each {|s| Thread.new(s) {|v| unify v, Net::HTTP.get_response(URI.parse("http://www.cuil.com/search?q=#{keyword}+#{rand(1000)}")).body } }
      stream.each {|s| Thread.new(s) {|http_body| client.call http_body.scan(/cuil/).length } }
      Thread.new { unify branding_occurences, stream.map {|http_body| http_body.scan /cuil/ } }
      Thread.new { unify number_of_mentions, branding_occurences.map {|occurences| occurences.length } }
      puts number_of_mentions.inspect
    end    
  end
end
  
Server = DataflowServer.new.method(:spider)
DRb.start_service('druby://localhost:8000', Server)
puts "Started drb server..."
DRb.thread.join
