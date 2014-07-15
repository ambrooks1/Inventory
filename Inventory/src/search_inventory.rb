#!/usr/bin/env ruby
require_relative 'constants.rb'
require_relative 'inventory_item'
require_relative 'inventory'

# parse the command line arguments
fieldname=ARGV[0]
searchStr=ARGV[1]

if fieldname.nil? || searchStr.nil?
   abort("Usage: ruby search_inventory.rb <fieldname> <search string>\n ex. ruby search_inventory.rb artist Pink")
end

inventory = Inventory.new
inventory.keyword_match( fieldname, searchStr)