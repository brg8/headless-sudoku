lambdabundle:
	bundle install --path vendor/bundle

lambdazip:
	zip -r function.zip lambda_function.rb bot.rb vendor

lambdaupdate:
	aws lambda update-function-code --function-name sudoku-solver --zip-file fileb://function.zip --region us-east-2 --profile personal

lambdify: lambdabundle lambdazip lambdaupdate