require "csv"

candidates = CSV.read(File.join(File.dirname(__FILE__), "data", "candidates.csv"), :headers => true)
candidate_count = candidates.group_by {|r| r["party"]}.reduce({}) {|m, (party, c)| m[party] = c.count; m }

locals_count = candidates.select{|c| c["ward"] == c["lives_in_ward"]}.group_by {|r| r["party"]}.reduce({}) {|m, (party, c)| m[party] = c.count; m }

scores =  candidate_count.reduce({}) {|m, (party, count)| m[party] = (locals_count[party].to_f / count * 100).to_i; m }
scores.invert.sort.reverse.map do |key,value|
  # keys will arrive in order to this block, with their associated value.
  puts "#{value}: #{key}%"
end


