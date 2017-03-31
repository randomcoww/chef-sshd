module SshdConfig

  ## sample source config
  # {
  #   "ClientAliveInterval" => 0,
  #   "ClientAliveCountMax" => 3,
  #   "UseDNS" => false,
  #   "PidFile" => "/var/run/sshd.pid",
  #   "MaxStartups" => "10:30:100",
  #   "PermitTunnel" => false,
  #   "ChrootDirectory" => "none",
  #   "VersionAddendum" => "none",
  #   "Banner" => "none",
  #   "AcceptEnv" => "LANG LC_*",
  #   "Subsystem" => ["sftp",	"/usr/lib/openssh/sftp-server"],
  #   "Match User anoncvs" => {
  #   	"X11Forwarding" => false,
  #   	"AllowTcpForwarding" => false,
  #   	"PermitTTY" => false,
  #   	"ForceCommand" => ["cvs", "server"]
  #   }
  # }


  def generate_config(config_hash)
    out = []

    config_hash.each do |k, v|
      parse_config_object(out, k, v, '')
    end
    return out.join($/)
  end

  def parse_config_object(out, k, v, prefix)
    case k
    when String
      k = [prefix, k].join
    when Array
      k = prefix + k.join(' ')
    end

    case v
    when Hash
      out << k
      v.each do |e, f|
        parse_config_object(out, e, f, prefix + '  ')
      end

    when Array
	     out << ([k] + v).join(' ')

    when String,Integer
      out << [k, v].join(' ')

    when TrueClass
      out << [k, 'yes'].join(' ')

    when FalseClass
      out << [k, 'no'].join(' ')

    when NilClass
      out << k
    end
  end
end

module Sshd
  CONFIG_PATH ||= '/etc/ssh/sshd_config'
end
