clear
coffee --compile --output test/lib/ test/src/ 
#mocha -t 10000 ./test/*.coffee --require should --compilers coffee:coffee-script -R spec
phantomjs node_modules/mocha-phantomjs/lib/mocha-phantomjs.coffee test/test_runner.html
