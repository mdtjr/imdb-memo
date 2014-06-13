require 'set'

class File

	TR = %r{<tr.*?</tr>}m

	GENRE_MERGED = %r{(?<=feature_|tv_series_).*?(?=_merged\.html)}



	def type
		case path
		when /documentary/ then "documentary"
		when /tv_series/ then "tv_series"
		when /feature/ then "feature"
		else "feature"
		end
	end

	def genre
		case path
		when /documentary/ then "documentary"
		when /[0-9]\.html/ then dirname.split("/").last
		else path[ GENRE_MERGED ]
		end
	end

	private def under50mb?(some_path)
		(File.size?(some_path) || 0) < 50_000_000
	end

	private def dirname
		File.dirname path
	end


	def rows &block
		read.scan( TR ).each do |tr|
			File.open json_path, "a" do |j|
				j.puts yield(tr)
			end
		end
	end

	def self.tt pathname
		Set.new self.read(pathname).scan(%r{title/tt\K[0-9]+}).map(&:to_i)
	end



	def json_memo_dirname
		path.sub(%r{/data/.+}, "/json/#{ genre }/#{ type }")
	end

	def siblings
		Dir[ File.join json_memo_dirname, "*.json" ]
	end

	def json_path
		File.join json_memo_dirname, json_fname
	end

	def json_fname
		if siblings.detect{|f| under50mb? File.join( json_memo_dirname, f) }
			siblings.detect{|f| under50mb? File.join( json_memo_dirname, f) }
		else
			siblings.count.to_s.rjust(2, "0") + ".json"
		end
	end









end