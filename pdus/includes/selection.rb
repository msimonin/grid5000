def select_pdus_nodes(root)
  elected_nodes = []
	root.sites.each do |site| 
		puts site["name"]
		site.clusters.each do |cluster| 
			puts cluster["uid"]
			cluster.nodes.each do |node| 
				sensors=node["sensors"]
				if sensors != nil
					power_sensor=sensors["power"]
					if power_sensor!= nil
						probes=power_sensor["via"]
						if probes!=nil
							ganglia_probe=probes["ganglia"]
							if ganglia_probe!=nil
								metric_name=""
								if ganglia_probe["metric"] == "shared_pdu"
									metric_name="pdu_shared" #reference API needs corrected here
								else
								 puts "non shared pdu found"
								 elected_nodes << node
								 metric_name=ganglia_probe["metric"]
								end
							end
						end
					end
				end
			end
		end
	end
  elected_nodes
end
