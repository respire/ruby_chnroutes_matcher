## ruby chnroutes matcher
a simple ipv4 chnroutes matcher implemented via ruby stdlib.


## Prerequisite
you should download a latest chnroutes file to make it work.

e.g. [from this repo](https://raw.githubusercontent.com/ym/chnroutes2/master/chnroutes.txt)

## Examples
### first, initialize an instance
```.rb
matcher = ChnroutesMatcher.new('chnroutes.txt')
```
### ip match
```.rb
matcher.ip_match?('115.239.210.27')
=> true

matcher.ip_match?('8.8.4.4')
=> false
```

### domain match
```.rb
# default nameservers are 114.114.114.114 and 1.1.1.1
matcher.domain_match?('www.bing.com')
=> true

matcher.domain_match?('zh.airbnb.com', nameservers: %w[8.8.4.4])
=> false
```

### lookup multiple domains
```.rb
# you can also pass custom nameservers like #domain_match?
res = matcher.lookup(['zh.airbnb.com', 'www.bing.com'])
puts res.to_yaml
=>
---
zh.airbnb.com:
  :domain: zh.airbnb.com
  :ip: 104.89.225.111
  :match: false
www.bing.com:
  :domain: www.bing.com
  :ip: 202.89.233.100
  :match: true
```
