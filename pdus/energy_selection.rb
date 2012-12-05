#list all node with non shared pdu
#try to reserve one of them

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

puts "nodes with dedicated pdu : #{elected_nodes.size()}"
puts "trying to reserve a free node"
to_be_reserved = nil
elected_nodes.each do |node| 
   puts "#{node["uid"]}"
   status=node.status(:query => { :reservations_limit => '5'})
   if status["system_state"] == "free"
     if status["reservations"].size > 0
       if Time.at(status["reservations"][0]["start_time"])-Time.now>= 1200 
         puts "#{node["uid"]} free (until #{Time.at(status["reservations"][0]["start_time"])})"
	 to_be_reserved = node
	 break
       else
         puts "#{node["uid"]} not available"
       end
    end
  end
end

if (to_be_reserved != nil)  then
  puts "reservation of #{to_be_reserved["uid"]}"
  to_be_reserved.parent.parent.jobs.submit(
                                 :resources  => "walltime=0:30:00",
                                 :command   => "sleep 3600",
			         :properties=> "host like '"+to_be_reserved["uid"]+".%'",
			         :name      => "test_pdu"
				 ) 
end
