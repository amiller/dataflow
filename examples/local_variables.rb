require "#{File.dirname(__FILE__)}/../dataflow"
include Dataflow

local do |x, y, z|
  # notice how the order automatically gets resolved
  Thread.new { unify y, x + 2 }
  Thread.new { unify z, y + 3 }
  Thread.new { unify x, 1 }
  puts z
end
  
