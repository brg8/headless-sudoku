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
ruby lambda_function.rb
```
