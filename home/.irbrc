require 'irb/completion'
require 'rubygems'
require 'wirble'
require 'irb/ext/save-history'

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb_history')

if defined? Wirble
  Wirble.init
  Wirble.colorize
end

if defined? Hirb
  Hirb.enable
end
