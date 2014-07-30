class php {

  # package install list
  $packages = [
#    "libapache2-mod-fastcgi",
    "php5-fpm",
    "php5",
    "php5-cli",
    "php5-mysql",
    "php-pear",
    "php5-dev",
    "php5-gd",
    "php5-mcrypt",
    "php5-xdebug",
    "php5-curl",
#    "php-apc" Zend opcode caching included in 5.5
  ]

  package { $packages:
    ensure => present,
    require => Exec["apt-get update"],
    notify => Service["php5-fpm"],
  }

  # create php-fpm config from main vagrant manifests
  file { "/etc/php5/fpm/pool.d/www.conf":
    ensure => present,
    content => template('php/fpm/pool.d/www.conf.erb'),
    require => Package["php5-fpm"],
  }

  # tell apache to use php5-fpm for .php requests
  file { "/etc/apache2/conf-available/php5-fpm.conf":
    ensure => present,
    content => template('php/apache/conf.d/php5-fpm.conf.erb'),
    require => Package["php5-fpm", "apache2"],
  }

   # tell apache to use php5-fpm for .php requests
  file { "/etc/apache2/conf-enabled/php5-fpm.conf":
    ensure => link,
    target => '/etc/apache2/conf-available/php5-fpm.conf',
    require => File["/etc/apache2/conf-available/php5-fpm.conf"],
    notify => Service["apache2"],
  }

  service { 'php5-fpm':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus   => true,
    restart => "/etc/init.d/php5-fpm restart",
    require => Package['php5-fpm']
  }

  # Set up some customised php.ini values
  file {'/etc/php5/fpm/conf.d/php_fpm.ini':
    ensure => present,
    content => template('php/fpm/conf.d/php5-fpm.ini.erb'),
    require => Package["php5-fpm"],
    notify => Service["php5-fpm"],
  }
}
