currentEnv = process.env.NODE_ENV or 'development'

exports.db =
  port: if currentEnv == 'development' then 6379 else process.env.DB_PORT
  host: if currentEnv == 'development' then "127.0.0.1" else process.env.DB_HOST
  pass: if currentEnv == 'development' then "foobared" else process.env.DB_PASS
exports.auth =
  facebook:
    id: if currentEnv == 'development' then "507048042640089" else process.env.AUTH_FACEBOOK_ID
    secret: if currentEnv == 'development' then "edc5c28038c0a2783b51dec80fdea351" else process.env.AUTH_FACEBOOK_SECRET
  twitter:
    id: if currentEnv == 'development' then "CMkKT5wVGNukREhvC68M7g" else process.env.AUTH_TWITTER_ID
    secret: if currentEnv == 'development' then "kqSXhbPzPM3CY5NT7Cbuk1ezsJfrWGNBd37Sdi7unQw" else process.env.AUTH_TWITTER_SECRET
