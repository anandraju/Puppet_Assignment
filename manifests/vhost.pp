class nginx::vhost($internal_hostname='UNSET' ,$domain='UNSET' ,$root='UNSET' ,$current_user='NIL') {
 
  include nginx 
  #$default_parent_root = "/home/ubuntu/nginxsites-puppet"
  $default_parent_root = "/var/www/puppetdemo"
 
 
  # Default value overrides
 
  if $domain == 'UNSET' {
    $vhost_domain = $name
  } 
    else {
    $vhost_domain = $domain
  }
 
  if $root == 'UNSET' {
    $vhost_root = "$default_parent_root/$name"
  } 
   else {
    $vhost_root = $root
  }
 
 
  file { "/etc/nginx/sites-available/${vhost_domain}.conf":
    content => template('nginx/vhost.erb'),
    require => Package['nginx'],
    notify  => Exec['reload nginx'], 
  }
 
 
  file { "/etc/nginx/sites-enabled/${vhost_domain}.conf":
    ensure  => link,
    target  => "/etc/nginx/sites-available/${vhost_domain}.conf",
    require => File["/etc/nginx/sites-available/${vhost_domain}.conf"],
    notify  => Exec['reload nginx'],
  }
 
 
  $dir_tree = [ "$default_parent_root", "$vhost_root", ]
 file { $dir_tree :
          owner   => 'ubuntu',
          group   => 'ubuntu',
          ensure  => 'directory',
          mode    => '777',
  }  ->   # This arrow ensures that the dir structure is created first.
  file {  ["$vhost_root/index.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
            source => "puppet:///modules/nginx/index-html",
            mode    => '755',
  } ->

  file {  ["$vhost_root/systeminfo.html"]:
            owner   => 'ubuntu',
            group   => 'ubuntu',
	    content => template('nginx/systeminfo.erb')
           # mode    => '755',
  }

}

