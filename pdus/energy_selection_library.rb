require 'rubygems'
require 'restfully'
require 'pp'
require_relative './includes/selection.rb'
require_relative './includes/reservation.rb'

Restfully::Session.new(
  :configuration_file => '~/.restfully/api.grid5000.fr.yml'
  ) do |root, session|

  pdus_nodes = select_pdus_nodes(root)
	puts "nodes with non shared pdu : #{pdus_nodes.size()}"
	puts "trying to reserve a free node"
  
	node = select_nodes(pdus_nodes)

	reserve_nodes(node)
	
end
