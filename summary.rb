require "csv"

candidates = CSV.read(File.join(File.dirname(__FILE__), "data", "candidates.csv"), :headers => true)
candidate_count = candidates.group_by {|r| r["party"]}.reduce({}) {|m, (party, c)| m[party] = c.count; m }

locals_count = candidates.select{|c| c["ward"] == c["lives_in_ward"]}.group_by {|r| r["party"]}.reduce({}) {|m, (party, c)| m[party] = c.count; m }
scores =  candidate_count.reduce({}) {|m, (party, count)| m[party] = (locals_count[party].to_f / count * 100).to_i; m }

count = 1
scores.invert.sort.reverse.map do |rank, party|

  candidates = candidate_count[party] || 0
  locals = locals_count[party] || 0
  puts "#{count}.\t#{party}:\t#{rank}%\t(#{locals}/#{candidates})"
  count += 1
end


# bourough_count = candidates.select{|c| c["lives_in_council"] == "Lambeth Borough Council"}.group_by {|r| r["party"]}.reduce({}) {|m, (party, c)| m[party] = c.count; m }
# p bourough_count
# borough_scores =  candidate_count.reduce({}) {|m, (party, count)| m[party] = (bourough_count[party].to_f / count * 100).to_i; m }
# p borough_scores
# count = 1
# borough_scores.invert.sort.reverse.map do |rank, party|

#   candidates = candidate_count[party] || 0
#   borough = bourough_count[party] || 0
#   puts "#{count}.\t#{party}:\t#{rank}%\t(#{borough}/#{candidates})"
#   count += 1
# end



