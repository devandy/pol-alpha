clear
#coffee -c ./test/login_test.coffee
mocha -t 10000 ./test/*.coffee --require should --compilers coffee:coffee-script -R spec
