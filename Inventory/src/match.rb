#!/usr/bin/env ruby
require_relative 'constants.rb'
require_relative 'match_record.rb'

class Match

=begin
		When a search is performed, we want to keep track
		of matches as the search progresses
=end
 
  def initialize
    @match_records=[]
  end
  

  # sort by search field ascending, release date descending
  def performSort(fieldname)
  
    if fieldname.downcase==ARTIST
        @match_records.sort! { |a,b| [a.artist.downcase, b.release_year] <=> [b.artist.downcase, a.release_year] }
    elsif  fieldname.downcase==TITLE
        @match_records.sort! { |a,b| [a.title.downcase, b.release_year] <=> [b.title.downcase, a.release_year] }
    elsif fieldname.downcase==RELEASE_YEAR
        @match_records.sort! { |a,b| b.release_year.downcase <=> a.release_year.downcase }
    end
  end
  
    # return the index if the release is found, regardless of media type
  def search( artist, title, release_year)
       for index in 0 ... @match_records.length
          
           match_rec = @match_records[index]
      
           if  	match_rec.artist == artist 	&&
          		match_rec.title == title 	&&
          		match_rec.release_year == release_year 
             return index
          end
       end
       return NOT_FOUND
  end
  
  def printAll
    @match_records.each {
     |match_record| 
            puts match_record.display 
    }
  end

  def insertNew(inven_item)
     mrec = MatchRecord.new
     mrec.populate(inven_item)
  	 @match_records.push(mrec)
  end

  def  updateMedia(index, format, quantity, id)
     mrec = @match_records[index]
     mrec.updateMedia(format, quantity, id)
  end
  
end