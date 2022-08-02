require 'irb/completion'
require 'rubygems'
require 'irb/ext/save-history'

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irb_history')

if defined? Hirb
  Hirb.enable
end
