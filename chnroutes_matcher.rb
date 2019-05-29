# frozen_string_literal: true

require 'ipaddr'
require 'resolv'

class ChnroutesMatcher
  def initialize(chnroutes_path)
    @dict = build_dict(chnroutes_path)
    @default_nameservers = ['114.114.114.114', '1.1.1.1']
  end

  def ip_match?(ip)
    ip = IPAddr.new(ip)
    candidates = @dict[ip.hton[0]]
    if candidates
      !candidates.index { |ipr| ipr.include?(ip) }.nil?
    else
      !@dict['escape'].index { |ipr| ipr.include?(ip) }.nil?
    end
  end

  def domain_match?(domain, nameservers: @default_nameservers)
    ip = nil
    Resolv::DNS.open(nameserver: nameservers) do |dns|
      ip = dns.getaddress(domain).to_s
    end
    ip_match?(ip)
  end

  def lookup(domains, nameservers: @default_nameservers)
    res = domains.map { |domain| [domain, { domain: domain, ip: nil, match: nil }] }.to_h

    Resolv::DNS.open(nameserver: nameservers) do |dns|
      res.each do |domain, item|
        begin
          item[:ip] = dns.getaddress(domain).to_s
          item[:match] = ip_match?(item[:ip])
        rescue Resolv::ResolvError
        end
      end
    end

    res
  end

  private

  def build_dict(chnroutes_path)
    chnroutes = File.read(chnroutes_path)
    chnroutes = chnroutes.split("\n")
    chnroutes.select! { |row| row.start_with?(/\d/) }
    dict = { 'escape' => [] }
    chnroutes.each do |row|
      _, mask = row.split('/')
      mask = mask.to_i
      ip = IPAddr.new(row)
      if mask <= 24
        fb = ip.hton[0]
        dict[fb] ||= []
        dict[fb] << ip.freeze
      else
        dict['escape'] << ip.freeze
      end
    end
    dict.each_value(&:freeze)
    dict.freeze
  end
end
