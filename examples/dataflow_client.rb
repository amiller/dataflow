require 'drb'
require 'thread'

class DataflowClient
  include DRbUndumped
  def occurences(occurences)
    puts "Google Occurences: #{occurences}"
  end
end

DRb.start_service('druby://localhost:8001')
obj = DRbObject.new(nil, 'druby://localhost:8000')
obj.call DataflowClient.new.method(:occurences), 'whatup'
