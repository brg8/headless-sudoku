# todo: log in to bot account so solutions are saved there
# todo: after solving one, output the account stats
# todo: check out aws lambda for fun times, maybe run once a day?

require_relative "bot.rb"
debug_file = "debugger.html"

s = SudokuBot.new
s.save
s.solve
s.fill
s.submit
if !s.check
  puts "[proc] check failed, saving debug log to #{debug_file}"
  s.debug debug_file
end
s.finish
