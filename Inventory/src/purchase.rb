#!/usr/bin/env ruby

require_relative 'inventory_item'
require_relative 'inventory'

############################ main #################################################################################


# parse the command line arguments
id=ARGV[0]
if id.nil?
   abort("Must provide id as command line argument :    ex.     ruby purchase.rb 123")
end

=begin
  we are going to do a purchase operation on this id
  so that if there are, say, 5 CDs in the inventory
  of George Garrison's "Concert for BangleDangle", 1974
  after the purchase, we should see only 4
=end

inventory = Inventory. new
inventory.purchase(id)
inventory.saveAll

