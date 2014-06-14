require 'irb/completion'
require 'rubygems'
require 'wirble'

IRB.conf[:USE_READLINE] = true

if defined? Wirble
  Wirble.init
  Wirble.colorize
end

if defined? Hirb
  Hirb.enable
end
