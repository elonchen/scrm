#encoding: utf-8
class PhoneAddress
	def self.load_config 
		YAML.load_file("#{Rails.root}/config/juhe.yml")[Rails.env]
	end

	def self.get(phone)
		config = self.load_config.symbolize_keys
		url = "/mobile/get"	
		uri = URI.parse(config[:host] + url)
		query_params = {
			:phone => phone,
			:key => config[:key],
			:dtype => 'json'
		}
		uri.query = URI.encode_www_form(query_params)

        response = JSON.parse(Net::HTTP.get_response(uri).body).symbolize_keys
        if response[:resultcode] == "200"
        	yield response[:result].symbolize_keys if block_given?
        else
        	raise response[:reason]
        end
	end
end