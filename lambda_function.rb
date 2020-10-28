# todo: log in to bot account so solutions are saved there
#    - may be able to just save a cookie and then check that we are in fact logged in
# todo: after solving one, output the account stats

# currently trying to run the selenium server and ruby script in a single docker container with a single Dockerfile
#   if i can accomplish this, then that should allow me to run the Dockerfile on practically any host

# aws lambda looks like the wrong tool for this
# what i want out of the running env
#  - less than $1 / year
#  - configuration is scripted (dockerized)

require_relative "bot.rb"
# debug_file = "debugger.html"

s = SudokuBot.new
s.save
s.solve
s.fill
s.submit
# if !s.check
#   puts "[proc] check failed, saving debug log to #{debug_file}"
#   s.debug debug_file
# end
s.finish
