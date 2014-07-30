# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}
$domain = "apachephpubuntu.loc"
include apt

apt::source { "internode_ubuntu_archiv_trusty":
        location        => "http://mirror.internode.on.net/pub/ubuntu/ubuntu/",
        release         => "trusty",
        repos           => "main restricted universe multiverse",
        include_src     => false,
        pin             => 501,
}

apt::source { "internode_ubuntu_archiv_trusty-updates":
        location        => "http://mirror.internode.on.net/pub/ubuntu/ubuntu/",
        release         => "trusty-updates",
        repos           => "main restricted universe multiverse",
        include_src     => false,
        pin             => 501,
}

apt::source { "internode_ubuntu_archiv_trusty-security":
        location        => "http://mirror.internode.on.net/pub/ubuntu/ubuntu/",
        release         => "trusty-security",
        repos           => "main restricted universe multiverse",
        include_src     => false,
        pin             => 501,
}

#include apache


class { 'apache':
  mpm_module => 'event'
}

#include apache::mod::prefork
#include apache::mod::php
include apache
include apache::mod::proxy
include apache::mod::rewrite
include apache::mod::headers

apache::mod { 'proxy_fcgi': }

apache::vhost { $domain:
  port    => '80',
  docroot => '/vagrant/web/',
  custom_fragment => template("app/apache_proxymatch.erb"),
  directories  => [
      { path           => '/vagrant/web/',
        allow_override => ['All'],
      },
    ],
}

#include sources
include bootstrap
include tools
include php
include mysql
include phpmyadmin

host { $domain:
    ip => '127.0.0.1',
}
