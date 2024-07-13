#!/usr/bin/env bash
# 100-puppet_ssh_config.pp
# Ensure the SSH configuration directory exists
file { '/home/ubuntu/.ssh':
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0700',
}

# Ensure the SSH config file exists
file { '/home/ubuntu/.ssh/config':
  ensure  => present,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0600',
  content => '',
}

# Add configuration to use the private key ~/.ssh/school
file_line { 'Declare identity file':
  path  => '/home/ubuntu/.ssh/config',
  line  => '    IdentityFile ~/.ssh/school',
  match => '^\\s*IdentityFile\\s+',
  notify => Exec['reload-ssh'],
}

# Add configuration to refuse to authenticate using a password
file_line { 'Turn off passwd auth':
  path  => '/home/ubuntu/.ssh/config',
  line  => '    PasswordAuthentication no',
  match => '^\\s*PasswordAuthentication\\s+',
  notify => Exec['reload-ssh'],
}

# Reload SSH service (if necessary)
exec { 'reload-ssh':
  command     => '/usr/bin/true',
  refreshonly => true,
}
