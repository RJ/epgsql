# fix weird dhcp in my office
file "/etc/resolv.conf" do
  content "nameserver 8.8.8.8"
end

include_recipe "apt"

include_recipe "epgsql::erlang"
include_recipe "epgsql::postgresql"

