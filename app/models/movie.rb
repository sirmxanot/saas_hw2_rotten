class Movie < ActiveRecord::Base
    def self.all_ratings
        ratings ||= Array.new
        Movie.all.each do |movie|
            ratings << movie.rating
        end
        ratings = ratings.uniq.sort
    end
end
