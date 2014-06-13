

def htmls
	Dir[ File.join File.dirname(__FILE__), "../data/**/*.html"].sort_by{ |f| File.size? f }
end


