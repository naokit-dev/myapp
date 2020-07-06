server '54.238.15.249',
   user: "sample_app",
   roles: %w{web app},
   ssh_options: {
       port: 22,
       user: "ec2-user", # overrides user setting above
       keys: %w(~/.ssh/EC2-sample_app.pem),
       forward_agent: true
#     auth_methods: %w(publickey password)
#     # password: "please use keys"
   }



