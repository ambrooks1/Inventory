#!/usr/bin/env ruby
require_relative 'constants.rb'

=begin
	used to collect information from match operations
=end

class MatchRecord
   attr_accessor  :artist, :title, :release_year, :media
   
   def initialize
   		@media = Hash.new
		@media = { CD => 0, CD_ID =>-1, TAPE => 0, TAPE_ID => -1, VINYL => 0, VINYL_ID => -1 }
   end
   
   def getTheId(name)
    case name
     	when CD
     		return @media[CD_ID]
     	when TAPE
     		return @media[TAPE_ID]
     	when VINYL
     		return @media[VINYL_ID]
     end
     return ""
   end
   
   def display
   	    already_displayed=false
   	    @media.each do|format_name,quant|
   	    
			if (!already_displayed && Integer(quant) > 0) 
					puts "Artist: " + @artist
					puts "Album: "  + @title
					puts "Released: " + @release_year
					already_displayed=true
			end
		   
			if  (( Integer(quant) > 0 ) && (format_name==CD || format_name==TAPE || format_name ==VINYL))
					puts "#{format_name}(" + "#{quant}): " + getTheId(format_name) 
			end
        end
        puts ""
   end
   
   def populate(inven_item)
     @artist = 			inven_item.artist
     @title = 			inven_item.title
     @release_year = 	inven_item.release_year
     
     case inven_item.format.upcase
     	when CD
     		@media[CD]=inven_item.quantity
     		@media[CD_ID]=inven_item.id
     	when TAPE
     		@media[TAPE]=inven_item.quantity
     		@media[TAPE_ID]=inven_item.id
     	when VINYL
     		@media[VINYL]=inven_item.quantity
     		@media[VINYL_ID]=inven_item.id
     end
   end
   
   def updateMedia(format, quantity, id)
    case format
     	when CD
     		@media[CD]=quantity
     		@media[CD_ID]=id
     	when TAPE
     		@media[TAPE]=quantity
     		@media[TAPE_ID]=id
     	when VINYL
     		@media[VINYL]=quantity
     		@media[VINYL_ID]=id
     end
   end
   
end