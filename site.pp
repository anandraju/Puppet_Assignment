node default {
   class { 'nginx::vhost':
	domain => 'puppetmaster.example.com',
	internal_hostname => $::networking['fqdn'],
	current_user => $::users
	#current_user => $::some_test#$::users
#	root => '/var/www/puppetdemo'
#	inter => $::os['distro']
	 } 

#	notify { $::os['distro']['codename']: } 
#	notify { $::networking['fqdn']: } 
}

