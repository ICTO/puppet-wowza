define wowza::application (
  $ensure     = present,
  $streamtype = 'live',
  $livestreampacketizers = 'cupertinostreamingpacketizer, smoothstreamingpacketizer',
  $playmethod = 'none',
  $rtmp_protect = 'false',
  $storagedir = undef,
) {

  $dir_ensure = $ensure ? {
    present => 'directory',
    true    => 'directory',
    default => 'absent',
  }

  # Create application folder
  file { "${wowza::params::installdir}/applications/${name}":
    ensure => $dir_ensure,
    force  => true,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Create application config file and folder
  file { "${wowza::params::installdir}/conf/${name}":
    ensure => $dir_ensure,
    force  => true,
    owner  => 'root',
    group  => 'root',
    mode   => '0755';
  }

  file { "${wowza::params::installdir}/conf/${name}/Application.xml":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('wowza/application.xml.erb'),
    notify  => Service['WowzaMediaServer'];
  }

  if $rtmp_protect == "true" {
    file { "${wowza::params::installdir}/conf/${name}/publish.password":
      ensure => $ensure,
      owner => 'root',
      group => 'root',
      mode => '0644',
      replace => false,
      source => 'puppet:///modules/wowza/publish.password';
    }
  }
}
