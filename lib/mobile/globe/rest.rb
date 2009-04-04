module Mobile::Globe::REST
  @@defaults = {
    :url       => 'http://iplaypen.globelabs.com.ph:1881/axis2/services/Platform'
  }

  class Client
    include ClassUtilMixin  
    @@ATTRIBUTES = [
      :user_name,
      :user_pin,
      :url,
    ]
    attr_accessor *@@ATTRIBUTES
  end
  @@config = Client.new(@@defaults)

  # TODO: configuration is shared among SOAP and REST
  def self.configure(&block)
    raise ArgumentError, "Block must be provided to configure" unless block_given?
    yield @@config

    [:user_name, :user_pin].each do |required|
      raise "#{required} must be configured" unless @@config.send(required)  
    end
    @@config
  end # configure


  class Client
    def send_sms(data)
      sms = data.is_a?(Mobile::Globe::SMS) ? data.to_h : Mobile::Globe::SMS.new(data).to_h
      sms.merge!(:uName => self.user_name, :uPin => self.user_pin) 
      create_http_post_request('sendSMS', sms)
    end

    def send_mms(data)
      mms = data.is_a?(Mobile::Globe::MMS) ? data.to_h : Mobile::Globe::MMS.new(data).to_h
      mms.merge!(:uName => self.user_name, :uPin => self.user_pin)
      create_http_post_request('sendMMS', mms)
    end

    protected

    def create_http_post_request(action, params = {})
      url = URI.parse("#{self.url}/#{action}") 
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data(params)
      #p req.body
      response = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        xml = Hpricot::XML(response.body || '')
        return Mobile::Globe::Response.new(xml.search("ns:return").first.inner_html)
      else
        res.error!
      end
    end

  end
end
