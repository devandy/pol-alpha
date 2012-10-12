currentEnv = process.env.NODE_ENV or 'development'

exports.db =
  port: if currentEnv == 'development' then 6379 else 10286
  host: if currentEnv == 'development' then "127.0.0.1" else "cod.redistogo.com"
  pass: if currentEnv == 'development' then "" else "95eca105b45271046e44e6484bf4fe15"
  url: if currentEnv == 'development' then "" else "redis://devandy:95eca105b45271046e44e6484bf4fe15@cod.redistogo.com:10286/"