#!/usr/bin/env ruby
require_relative 'constants.rb'
require_relative 'inventory_item'
require_relative 'inventory'
require 'csv'

=begin
  Inventory file looks like this

  UID | Quantity | Format | Release year | Artist | Title

  1.   Load the existing inventory into memory, an array of inventory objects
  2.   Read in a shipping manifest file ( SM)
         for each SM line
           if it is already present in the inventory, update the quantity
           else create a new Inventory record with a new ID
  3.  Write the updated inventory back out to a file
=end

def initFromPipeArr( array)
=begin
the input comes from a pipe-delimited manifest
2 | VINYL | 1993 | Nirvana | In Utero
=end
      inventoryItem = InventoryItem.new
      
      inventoryItem.id =            -1;
      inventoryItem.quantity =      array[0].strip
      inventoryItem.format=   		array[1].strip
      inventoryItem.release_year =  array[2].strip
      inventoryItem.artist=   		array[3].strip
      inventoryItem.title=    		array[4].strip
     
      return inventoryItem
end

def initFromCSVArr(array)
=begin
the input comes from a comma-delimited manifest
Paula Abdul,Forever Your Girl,cd,1988
=end
      inventoryItem = InventoryItem.new
      
      inventoryItem.id =            -1;
      inventoryItem.quantity=       1;
      inventoryItem.artist =        array[0].strip
      inventoryItem.title=   		array[1].strip
      inventoryItem.format =        array[2].strip
      inventoryItem.release_year=   array[3].strip
    
      return inventoryItem
end

def load_manifest(inputfile, inventory)
# inputfile could be either a .csv or .pipe format

    if inputfile.end_with? ".csv"
  		isCSV=true
	else
  		isCSV=false
  	end
  	
  	mode = "r"
	infile = File.open(inputfile, mode)

	File.foreach(inputfile) {
     	 |line| 
     	     puts "MANIFEST LINE: " + line
        
         line_items = []
         if isCSV
            # kludge to convert an array of array into an array
            foo=[[]]
            foo=  CSV.parse(line)
            line_items=foo[0]
            
            inv_item = initFromCSVArr(line_items)
         else
            line_items  = line.split("|")
            inv_item = initFromPipeArr(line_items)
         end
         
         # puts inv_item.inspect 
         #  if the item is already present in the inventory, update the quantity of this item
         #  else create a new Inventory record with a new ID
         
         index = inventory.search(inv_item)
         
         # if found, we have the index - else if not found we have -1
         
        # puts "Result of find operation on Inventory is :" + index.to_s
         
         if index == NOT_FOUND
            inventory.insertNew(inv_item)
         else
            inventory.addToQuantity(inv_item.quantity, index)
         end
	}

end
#######    START of main routine 

inputfile=ARGV[0]
if inputfile.nil? 
   abort("Usage: ruby load_inventory.rb <inputfile>\n ex. ruby search_inventory.rb  music_bucket.pipe")
end

inventory = Inventory. new
#inventory.printAll

fullpath=DATA + inputfile
load_manifest(fullpath, inventory)

inventory.saveAll
