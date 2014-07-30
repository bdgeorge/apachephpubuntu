class phpmyadmin {

  package { 'phpmyadmin':
    ensure => present,
    require => Exec["apt-get update"]
  }

 # linux way: ln -s /etc/phpmyadmin/apache.conf /etc/apache2/sites-available/phpmyadmin.conf
  file { '/etc/apache2/conf-available/phpmyadmin.conf':
    ensure => link,
    target => '/etc/phpmyadmin/apache.conf',
    require => Package['phpmyadmin', 'apache2', 'php5-fpm'],
    notify => Service["apache2"],
  }

    # tell apache to use php5-fpm for .php requests
  file { '/etc/apache2/conf-enabled/phpmyadmin.conf':
    ensure => link,
    target => '/etc/phpmyadmin/apache.conf',
    require =>  Package['phpmyadmin', 'apache2', 'php5-fpm'],
    notify => Service["apache2"],
  }

}