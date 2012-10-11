currentEnv = process.env.NODE_ENV or 'development'

exports.db =
  port: if currentEnv == 'development' then 6379 else 9201
  host: if currentEnv == 'development' then "127.0.0.1" else "fish.redistogo.com"
  pass: if currentEnv == 'development' then "" else "03fe3dce079dfcd12560cdebe05631a0"