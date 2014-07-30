define mysqldb( $user, $password ) {
  #TODO: this unless doesn't seem to work as expected
    exec { "create-${name}-db":
      unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
      command => "/usr/bin/mysql -uroot -p$mysql::mysqlpw -e \"create database ${name}  CHARACTER SET utf8 COLLATE utf8_general_ci; grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
      require => Exec["set-mysql-password"],
    }
  }