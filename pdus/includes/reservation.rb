def select_nodes(nodes)
  # first fit - one node
  selected = nil
  nodes.each do |node|
     puts "#{node["uid"]}"
     status=node.status(:query => { :reservations_limit => '5'})
     if status["system_state"] == "free"
       if status["reservations"].size > 0
         if Time.at(status["reservations"][0]["start_time"])-Time.now>= 1200
           puts "#{node["uid"]} free (until #{Time.at(status["reservations"][0]["start_time"])})"
           selected = node
           break
         else
           puts "#{node["uid"]} not available"
         end
      end
    end
  end
  selected
end

def reserve_nodes(nodes)
 # reserve one node for 20 min
 if (nodes != nil)  then
    puts "reservation of #{nodes["uid"]}"
    nodes.parent.parent.jobs.submit(
                                   :resources  => "walltime=0:20:00",
                                   :command   => "sleep 3600",
                                   :properties=> "host like '"+nodes["uid"]+".%'",
                                   :name      => "test_pdu"
           )
  end
end
