#!/usr/bin/env ruby
require_relative 'constants.rb'
require_relative 'match.rb'

=begin
  Inventory file records look like this

  UID | Quantity | Format | Release year | Artist | Title

=end

class Inventory

  # we use max_id to get a new id
  # when we create a new inventory record
  
  @@max_id=-1
  
  def initialize
	load_from_file
	
	# @match is the object which contains the array that we populate, on the fly, as a response to a search
	@match = Match.new
  end

# give the id of the inventory item to purchase, subtract one from the media type.
# print a purchase message
# If there were none in stock, print an apologetic error message

  def doPurchase(item)
     item.quantity = Integer(item.quantity)
	 if item.quantity > 0
	   item.quantity = item.quantity - 1
	   puts "Removed 1 " + item.format + " of " + item.title + " by " + item.artist + " from the inventory"
	 else
	   puts "Sorry, we have no more " + item.format + " format of title: " +  item.title +  " by artist: " + item.artist + " at this time."
	 end
  end

  def  purchase(id)
     found=false
     @inventory_arr.each do |item | 
	      if item.id == id
	         found=true
	         doPurchase(item)
	         break
	      end
	  end
	  if !found 
	     puts "Invalid id " + id
	  end
  end
  
  # write out the whole inventory list from memory to disk
  def saveAll
    mode = "w"
	outfile = File.open(INVENTORY, mode)
  
	@inventory_arr.each do | item |
	    outfile.puts item.toPipeDelim
	end
	outfile.close
  end
  
  # for debugging purposes, display the whole inventory 
  def printAll
    @inventory_arr.each { |x| puts x.display }
  end

# inserting a new inventory record into memory
  def insertNew(item)
  
     @@max_id = @@max_id + 1
  	 item.id = @@max_id
  	 
  	 @inventory_arr.push(item)
  end

=begin
	for all inventory items in the inventory array, looking only at fieldname. 
	{
	  If the searchSubstring matches the fieldname value
	   then
	     search the match_record array for this inventory item, matching only on artist, title and release year.
	     if found, then just update the media hash of the match record
	     else ( if not found ) put in a new entry into the match record array.
	   end
	  end
	}
	finally, print out the match record array
=end

  def keyword_match( fieldname, searchSubstring)
  
     @inventory_arr.each {
         |inventory_item|   inventory_item.myMatcher(fieldname,  searchSubstring, @match) 
     }
     
     ## now the array contained in @match object is loaded with the results of the keyword_match search
     
     @match.performSort(fieldname)
     
     @match.printAll
  end

# if an inventory item exists, return its index in memory
  def  search(item)
    
       @inventory_arr.each_with_index do |inv_item,index|
       
          #puts "in findItem :", index, inv_item
          if  item == inv_item 
             return index
          end
       end
       return NOT_FOUND
  end
  
  # We are updating info for extra copies of existing media for a title
  def addToQuantity(quant, index)
  	item = @inventory_arr[index]
  	item.quantity =  Integer(item.quantity) + Integer(quant)
  end
  
  private 

   def load_from_file
    mode = "r"
	infile = File.open(INVENTORY, mode)
	@inventory_arr = []

	File.foreach(infile) {
    	 |line| 
    	 #puts "INVENTORY LINE " + line
    	 new_item = createItemFromLine(line)
    	 if new_item.nil?
    	   next
    	 end
    	 #new_item.display
    	 
    	 if Integer(new_item.id) > @@max_id
    	 	@@max_id = Integer(new_item.id)
    	 end
     	 @inventory_arr << new_item
	}
	infile.close
  end
end

private



 # during load inventory, we are converting a text line to an object
  def createItemFromLine(line)
      line_items = []   
      			# is this line needed?
      line_items = line.split("|")
      
      # a valid inventory line should have six fields
      if line_items.length != 6
        return nil
      end
      item = InventoryItem.new
      item.initFrom(line_items)
      return item
  end
