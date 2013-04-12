module PollsHelper
	def pagnation curr_page,end_page,next_pages
    bound_1 = curr_page - next_pages
    bound_2 = curr_page + next_pages
    if end_page >= next_pages * 2 + 1
      if bound_1 > 0 && bound_2 <= end_page
      elsif bound_1 < 0
        bound_1 = 1
        bound_2 = bound_1 + next_pages * 2
      elsif bound_2 > end_page
        bound_2 = end_page
        bound_1 = bound_2 - next_pages * 2
      end
    else
      bound_1 = curr_page
      bound_2 = end_page
    end
    return {:min => bound_1,:max => bound_2}
	end
end

