# headless-sudoku

Because sometimes you just want to build something. Could be fun to add some machine learning to identify a sudoku-like html structure and parse it automatically.

# start your chrome/selenium environment

Start a docker container from the project directory.
```
chmod +x docker.sh
./docker.sh
```

Confirm the container is running.
```
docker ps
```

# run the ruby script

Install gems
```
bundle install
```

Release the bot!
```
ruby script.rb
```

# debug

If the script's success check fails it will output the current page's html to debugger.html. You should be able to load that file in your local browser to see what went wrong.
