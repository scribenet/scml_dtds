f = File.readlines("scml.dtd")

# this scans a dtd for element names
# it ignores the comments at the beginning of the page
# it is tightly coupled to the formatting of the Scml dtd, so in the unlikely event that changes, this will need to be updated as well.
#
# works with unix line endings
# run mac2unix to convert the dtd before using this script.
#
#
# to use: make a file of element names, one per line.
#
# ruby check_dtd.rb present FILE
#    - will print out a list of all the element names in the FILE that are present in the dtd
#
# ruby check_dtd.rb absent FILE
#    - will print out a list of all the element names in the FILE that are not in the dtd

elements = f.grep(/<!ELEMENT (.*)(\s+)\(|<!ELEMENT (.*)$/){$1}
data_group_elements = f.join.slice(/<!ENTITY % data\.group(.*)Character Entities/m, 1).split(/\n|\r/).grep(/\| ([^">]*)/){$1}
other_group_elements = f.grep(/\| [^|]* \|/).reject{ |e| e.match /<!ELEMENT|type \(/}.map{|s| s.gsub(/[\s>"]/, "").split("|") }.flatten

element_and_type_lists = f.select {|e| e.match /<!ELEMENT|type \(/}.grep(/(\(.*\))/){$1}.map{|s| s.gsub(/[\s*?();+]/, "").split(/[,|]/)}.flatten.uniq

element_places = [elements, data_group_elements, other_group_elements, element_and_type_lists]

def present_in_dtd?(element_places, name)
  element_places.map{|group| group.include?(name)}.inject(false){|collector, result| collector or result}
end

look_for_present_or_absent = ARGV[0]
elements = File.read(ARGV[1]).split(/\n|\r/).reject{|e| e == ""}

if look_for_present_or_absent == "present"
  elements.each do |ele|
    puts ele if present_in_dtd?(element_places, ele)
  end
end


if look_for_present_or_absent == "absent"
  elements.each do |ele|
    puts ele unless present_in_dtd?(element_places, ele)
  end
end
