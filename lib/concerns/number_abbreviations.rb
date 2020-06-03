module NumberAbbreviation

	def abbreviate_number(num)
		magnitude = num/1000
		case magnitude
			when 0..9
			  "#{num}"
			when 10..999
			  "#{num/1000}k"
			else
			  "#{num/1000000}M"
		end
	end

	def reverse_abbreviation(str)
		if str.include?('k')
			str.gsub('k', '')
			num = str.to_f * 1000
			num.to_i
		elsif str.include?('M')
			str.gsub('M', '')
			num = str.to_f * 1000000
			num.to_i
		else
			str.to_f
		end
	end

end