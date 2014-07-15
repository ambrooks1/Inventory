#!/usr/bin/env ruby

require_relative 'constants.rb'

=begin
  Inventory file looks like this

  UID | Quantity | Format | Release year | Artist | Title
=end

class InventoryItem
   attr_accessor :id, :artist, :title, :format, :release_year, :quantity
  
   def toPipeDelim
   	 return  [@id, @quantity, @format, @release_year, @artist, @title ].join('|')
   end
   
   def initFrom(array)
      @id          =        array[0].to_s.strip
      @quantity=            array[1].to_s.strip
      @format=              array[2].to_s.strip.upcase
      @release_year =       array[3].to_s.strip
      
      @artist=              array[4].to_s.strip
      @title=               array[5].to_s.strip
   end


# test to see if two inventory items are the same, irrespective of id or quantity
# also irrespective of the alpha case of artist and title

  def ==(another_inv_item)
      self.artist.casecmp(another_inv_item.artist) == 0 &&
      self.title.casecmp(another_inv_item.title)   == 0 &&
      self.format.casecmp(another_inv_item.format) == 0 &&
      self.release_year ==  another_inv_item.release_year 
  end
  
=begin
	
	  If the searchStr matches the fieldname value
	   then
	     search the match_record array for this inventory item, matching only on artist, title and release year.
	     
	     if found, then just update the media hash of the match record
	     else ( if not found ) put in a new entry into the match record array.
	   end
	  end
	
=end

  def match_action(match)							 
		index = match.search( @artist, @title, @release_year)
		
		if index == NOT_FOUND
			match.insertNew(self)
		else
			match.updateMedia(index, @format, @quantity, @id)
		end
  end
  

## Check whether the value of searchStr
## is inside field or not.

  def stringMatch (searchStr, field)   			
   if(field =~ /#{searchStr}/)
      return true
   end
    return false   
  end     
  
  
  def test_for_match(searchStr, field, match)
     match_action(match) if  stringMatch(searchStr, field)  	
  end
           
                                                           
  def myMatcher(field, searchStr, match)
  
   	    if field == "artist"  
   			   test_for_match(searchStr, @artist, match)  				 								
   		elsif field == "title" 
   		       test_for_match(searchStr @title, match)  				 								
   		elsif field == "release_year" 
   			   test_for_match(searchStr,   @release_year, match)  			 								
   		else
   				puts "Field not found :" + field
   		end
   end
   
 end   


