##
## Define the postgres settings we want, then include the postgresql recipe
##

file "/etc/resolv.conf" do
  content "nameserver 8.8.8.8"
end

include_recipe "apt"
# package "git"

# bash "install BATS test framework" do
#   not_if "test -f /usr/local/bin/bats"
#   code <<-EOF
#     cd /tmp/
#     git clone https://github.com/sstephenson/bats.git
#     cd bats
#     ./install.sh /usr/local
#   EOF
# end

node.set['postgresql']['password']['postgres'] = "epgsql"

node.set["postgresql"]["config"] = {
  :ssl => true,
  :ssl_ca_file => "/etc/ssl/certs/ca-certificates.crt"
}

user = "vagrant"

hba_def = <<EOF
local   all             #{user}                   nil             trust
host    template1       #{user}                   127.0.0.1/32    trust
host    #{user}         #{user}                   127.0.0.1/32    trust
host    epgsql_test_db1 #{user}                   127.0.0.1/32    trust
host    epgsql_test_db1 epgsql_test               127.0.0.1/32    trust
host    epgsql_test_db1 epgsql_test_md5           127.0.0.1/32    md5
host    epgsql_test_db1 epgsql_test_cleartext     127.0.0.1/32    password
hostssl epgsql_test_db1 epgsql_test_cert          127.0.0.1/32    cert clientcert=1
EOF

hba = hba_def.split("\n").map {|line|
  f = line.split(" ", 5)
  {:type => f[0],
   :db => f[1],
   :user => f[2],
   :addr => f[3] == "nil" ? nil : f[3],
   :method => f[4]}
}

node.set["postgresql"]["pg_hba"] = hba

include_recipe "postgresql::client"
include_recipe "postgresql::server"
