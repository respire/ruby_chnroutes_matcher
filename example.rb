require_relative 'chnroutes_matcher'
require 'yaml'

matcher = ChnroutesMatcher.new('chnroutes.txt')
STDOUT << "matcher.ip_match?('115.239.210.27')\n=> #{matcher.ip_match?('115.239.210.27')}\n\n"
STDOUT << "matcher.ip_match?('8.8.4.4')\n=> #{matcher.ip_match?('8.8.4.4')}\n\n"

STDOUT << "matcher.domain_match?('www.baidu.com')\n=> #{matcher.domain_match?('www.baidu.com')}\n\n"
STDOUT << "matcher.domain_match?('zh.airbnb.com', nameservers: %w[1.1.1.1])\n=> #{matcher.domain_match?('zh.airbnb.com', nameservers: %w[1.1.1.1])}\n\n"

STDOUT << "matcher.lookup(['www.bing.com', 'zh.airbnb.com'])\n=> #{matcher.lookup(['www.bing.com', 'zh.airbnb.com']).to_yaml}\n\n"
STDOUT << "matcher.lookup(['www.bing.com', 'zh.airbnb.com'], nameservers: %w[8.8.4.4])\n=> #{matcher.lookup(['www.bing.com', 'zh.airbnb.com'], nameservers: %w[8.8.4.4]).to_yaml}\n\n"
