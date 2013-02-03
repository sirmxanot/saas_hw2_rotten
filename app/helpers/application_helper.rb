module ApplicationHelper
  def sortable(column, title=nil, selected_ratings)
    title ||= column.titleize
        
    if column == sort_column && sort_direction == "asc"
        direction = "desc"
    else direction = "asc"
    end

    if column == sort_column
        css_class = "hilite"
    else css_class = nil
    end

    link_to title, {:sort => column, :direction => direction, 
      :ratings => @selected_ratings}, {:class => css_class}
  end   

  def checked?(rating)
    checked_ratings.has_key?(rating) ? true : nil
  end
end
