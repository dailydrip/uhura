require 'systemu'
require 'socket'

module Mac
  def Mac.dependencies
    {
        'systemu' => [ 'systemu' , '~> 2.6.5' ]
    }
  end

  def Mac.description
    'cross platform mac address determination for ruby'
  end


  class << self

    attr_accessor "mac_address"

    # Discovers and returns the system's MAC addresses.  Returns the first
    # MAC address, and includes an accessor #list for the remaining addresses:
    #
    #   Mac.addr # => first address
    #   Mac.addr.list # => all addresses

    def address
      return @mac_address if defined? @mac_address and @mac_address

      @mac_address = from_getifaddrs
      return @mac_address if @mac_address

      cmds = '/sbin/ifconfig', '/bin/ifconfig', 'ifconfig', 'ipconfig /all', 'cat /sys/class/net/*/address'

      output = nil
      cmds.each do |cmd|
        _, stdout, _ = systemu(cmd) rescue next
        next unless stdout and stdout.size > 0
        output = stdout and break
      end
      raise "all of #{ cmds.join ' ' } failed" unless output

      @mac_address = parse(output)
    end

    link   = Socket::PF_LINK   if Socket.const_defined? :PF_LINK
    packet = Socket::PF_PACKET if Socket.const_defined? :PF_PACKET
    INTERFACE_PACKET_FAMILY = link || packet # :nodoc:

    def from_getifaddrs
      return unless Socket.respond_to? :getifaddrs

      interfaces = Socket.getifaddrs.select do |addr|
        if addr.addr  # Some VPN ifcs don't have an addr - ignore them
          addr.addr.pfamily == INTERFACE_PACKET_FAMILY
        end
      end

      mac, =
          if Socket.const_defined? :PF_LINK then
            interfaces.map do |addr|
              addr.addr.getnameinfo
            end.find do |m,|
              !m.empty?
            end
          elsif Socket.const_defined? :PF_PACKET then
            interfaces.map do |addr|
              addr.addr.inspect_sockaddr[/hwaddr=([\h:]+)/, 1]
            end.find do |mac_addr|
              mac_addr != '00:00:00:00:00:00'
            end
          end

      @mac_address = mac if mac
    end

    def parse(output)
      lines = output.split(/\n/)

      candidates = lines.select{|line| line =~ RE}
      raise 'no mac address candidates' unless candidates.first
      candidates.map!{|c| c[RE].strip}

      maddr = candidates.first
      raise 'no mac address found' unless maddr

      maddr.strip!
      maddr.instance_eval{ @list = candidates; def list() @list end }
      maddr
    end

    alias_method "addr", "address"
  end

  RE = %r/(?:[^:\-]|\A)(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F](?:[^:\-]|\Z)/io
end

MacAddr = Macaddr = Mac

module IP
  class << self
    def address
      ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
      ip.ip_address if ip
    end
    alias_method "addr", "address"
  end
end

module Host
  class << self
    def name
      Socket.gethostname
    end
  end
end