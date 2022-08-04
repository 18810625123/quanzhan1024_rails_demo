load 'app/my/redis/base.rb'
load 'app/my/redis/stack.rb'
load 'app/my/redis/set.rb'
load 'app/my/redis/zset.rb'
load 'app/my/redis/number.rb'
load 'app/my/redis/hash.rb'

load 'app/my/client/base.rb'
load 'app/my/client/sms.rb'
load 'app/my/client/wx.rb'
load 'app/my/client/bd.rb'

load 'app/my/error/base.rb'

module My

  class << self

    def ips
      return @ips if @ips
      @ips = {}
      str=""
      str.split("\n").each do |a|
        arr = a.split(":")[1].split(',')
        @ips[a.split(":")[0]] = {
          province: arr[0],
          city: arr[1],
          district: arr[2],
          isp: arr[3],
        }
      end
      puts "解析"
      @ips
    end

    def parse_ip ip
      headers={
        'User-Agent': 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.0.0 Safari/537.36',
      }
      ip_obj = Client::Base.get("https://restapi.amap.com/v5/ip?type=4&key=50f757559f4d7206d75d08015c19f374&ip=" + ip,{},headers)
      JSON.parse(ip_obj)
    rescue
      Rails.logger.error "解析ip（#{ip}）失败"
      nil
    end

    def rand_str len
      "#{(rand * 10 + 1).to_s[0]}#{rand.to_s[2..(len)]}"
    end

    def is_email? str
      return false if str.count('@') != 1
      a, b = str.split('@')
      return false if !a.match? /^\w{1,30}$/
      return false if b.count('.') != 1
      b1, b2 = b.split '.'
      return false if !b1.match? /^\w{1,10}$/
      return false if !b2.match? /^[A-Za-z]{1,10}$/
      true
    end

    def is_email_code? str
      str.match? /^[0-9]{6}$/
    end

    def is_phone? str
      str.match? /^1[0-9]{10}$/
    end

    def now_time_str senconds
      (Time.new + senconds).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end