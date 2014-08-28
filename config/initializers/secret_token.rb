# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Deploy::Application.config.secret_key_base = '182e6da218f500f9c3c25b3ac4dadb2d86aed523bcd1b4654195a3958acc3bdf9cde47cc0a059afff10006a450f97e20ba7198f6695e1b47e1f52e8452e20b74'
