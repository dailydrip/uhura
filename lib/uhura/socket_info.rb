# frozen_string_literal: true

require 'systemu'
require 'socket'

module Mac
  def self.dependencies
    {
      'systemu' => ['systemu', '~> 2.6.5']
    }
  end

  def self.description
    'cross platform mac address determination for ruby'
  end

  class << self
    attr_accessor :mac_address

    # Discovers and returns the system's MAC addresses.  Returns the first
    # MAC address, and includes an accessor #list for the remaining addresses:
    #
    #   Mac.addr # => first address
    #   Mac.addr.list # => all addresses

    # rubocopXXX:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
    def address
      # rubocop:disable Style/AndOr
      return @mac_address if defined? @mac_address and @mac_address

      # rubocop:enable Style/AndOr

      @mac_address = from_getifaddrs
      return @mac_address if @mac_address

      output = ifconfig_cmd_output
      @mac_address = parse(output)
    end

    def ifconfig_cmd_output
      cmds = '/sbin/ifconfig', '/bin/ifconfig', 'ifconfig', 'ipconfig /all', 'cat /sys/class/net/*/address'
      output = nil
      cmds.each do |cmd|
        begin
          _, stdout = systemu(cmd)
        rescue StandardError
          next
        end
        # rubocop:disable Style/SafeNavigation
        next unless stdout && stdout.size.positive?

        # rubocop:enable Style/SafeNavigation
        output = stdout && break
      end
      raise "all of #{cmds.join ' '} failed" unless output
    end

    link   = Socket::PF_LINK   if Socket.const_defined? :PF_LINK
    packet = Socket::PF_PACKET if Socket.const_defined? :PF_PACKET
    INTERFACE_PACKET_FAMILY = link || packet # :nodoc:

    def from_getifaddrs
      return unless Socket.respond_to? :getifaddrs

      interfaces = Socket.getifaddrs.select do |addr|
        # Some VPN ifcs don't have an addr - ignore them
        addr.addr.pfamily == INTERFACE_PACKET_FAMILY if addr.addr
      end

      mac = get_mac(interfaces)
      @mac_address = mac if mac
    end

    def get_mac(interfaces)
      if Socket.const_defined? :PF_LINK then get_nameinfo(interfaces)
      elsif Socket.const_defined? :PF_PACKET then get_sockaddr(interfaces)
      end
    end

    def get_nameinfo(interfaces)
      nameinfo = interfaces.map do |addr|
        addr.addr.getnameinfo
      end
      nameinfo.find do |m,|
        !m.empty?
      end
    end

    def get_sockaddr(interfaces)
      sockaddr = interfaces.map do |addr|
        addr.addr.inspect_sockaddr[/hwaddr=([\h:]+)/, 1]
      end
      sockaddr.find do |mac_addr|
        mac_addr != '00:00:00:00:00:00'
      end
    end

    def parse(output)
      lines = output.split(/\n/)

      candidates = lines.select { |line| line =~ RE }
      raise 'no mac address candidates' unless candidates.first

      candidates.map! { |c| c[RE].strip }

      maddr = candidates.first
      raise 'no mac address found' unless maddr

      maddr.strip!
      maddr.instance_eval do
        @list = candidates
        def list
          @list
        end
      end
      maddr
    end

    alias addr address
  end

  RE = /(?:[^:\-]|\A)(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F](?:[^:\-]|\Z)/io.freeze
end

MacAddr = Macaddr = Mac

module IP
  class << self
    def address
      ip = Socket.ip_address_list.detect(&:ipv4_private?)
      ip&.ip_address
    end
    alias addr address
  end
end

module Host
  class << self
    def name
      Socket.gethostname
    end
  end
end
