currentEnv = process.env.NODE_ENV or 'development'

exports.db =
  port: if currentEnv == 'development' then 6379 else process.env.DB_PORT
  host: if currentEnv == 'development' then "127.0.0.1" else process.env.DB_HOST
  pass: if currentEnv == 'development' then "foobared" else process.env.DB_PASS
  url: if currentEnv == 'development' then "" else process.env.DB_URL