class Movie < ActiveRecord::Base
  def self.all_ratings
      ratings ||= Array.new
      Movie.all.each do |movie|
          ratings << movie.rating
      end
      ratings = ratings.uniq.sort
  end

  def self.filter(ratings)
      if ratings
          Movie.where(:rating => ratings.keys)
      else
          Movie.all
      end
  end
end
