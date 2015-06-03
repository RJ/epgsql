include_recipe 'apt'

apt_repository 'erlang_solutions_repo' do
  uri 'http://packages.erlang-solutions.com/ubuntu/'
  distribution node['lsb']['codename']
  components ['contrib']
  key 'http://packages.erlang-solutions.com/debian/erlang_solutions.asc'
  trusted true
  action :add
end

package "erlang-nox"
#package "erlang-dev"
package "rebar"
