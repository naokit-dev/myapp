server '54.238.15.249',
   user: "sample_app",
   roles: %w{web app},
   ssh_options: {
       port: 22,
       user: "sample_app", # overrides user setting above
       keys: %w(~/.ssh/sample_app_key_rsa),
       forward_agent: true
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
   }



