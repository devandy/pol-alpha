clear
# mocha -t 10000 ./test/*.coffee --require should --compilers coffee:coffee-script -R spec
coffee --compile --output test/lib/ test/src/
./node_modules/mocha-phantomjs/bin/mocha-phantomjs /home/andy/dev/js/pol-alpha/test/test.html