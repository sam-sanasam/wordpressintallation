# update using apt                                                                                                 
exec{"apt update":                                                                                                 
path=> "/usr/bin"  
}                                                                                                                  
                                                                                                                   
# Apache Installation                                                                                              
                                                                                                                   
package{"apache2":                                                                                                 
ensure=> present,                                                                                                  
}                                                                                                                  
                                                                                                                   
# Managing the service                                                                                             
service{"apache2":                                                                                                 
ensure=>"running",                                                                                                 
}                                                                                                                  
                                                                                                                   
                                                                                                                   
# Package installation                                                                                             
$allpackage=['mysql-server','mysql-client','php','libapache2-mod-php','php-mcrypt','php-mysql']                    
$allpackage.each |String $pack|{                                                                                   
        package{"$pack":                                                                                           
        ensure=> present,                                                                                          
        }                                                                                                          
}                                                                                                                  
                                                                                                                   
# seting up the authentification                                                                                   
exec{"mysqladmin -u root password rootpassword && touch /var/mysqlrootset":                                                                                                 
path=> "/usr/bin",  
creates => "/var/mysqlrootset"
                                                                              
}                                                                                                                  
                                                                                                                   
                                                                                                                   
# wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands      
                                                                                                                   
                                                                                                                   
package{"wget":                                                                                                    
ensure=> present,                                                                                                  
}   

exec{"wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands":
path=> "/usr/bin",
cwd=> "/tmp",
creates => "/tmp/mysqlcommands"
}

#mysql -uroot -prootpassword < /tmp/mysqlcommands
exec{"mysql -uroot -prootpassword < /tmp/mysqlcommands && touch /var/mysqlimportcomplete":                                                                                                 
path=> "/usr/bin",
creates => "/var/mysqlimportcomplete"
}   




#wget https://wordpress.org/latest.zip

exec{"wget https://wordpress.org/latest.zip":
path=> "/usr/bin",
cwd=> "/tmp",
creates =>"/tmp/latest.zip"
}

#sudo apt install -y unzip
package{"unzip":
ensure=>present,
}



#sudo unzip /tmp/latest.zip -d /var/www/html
exec{"unzip /tmp/latest.zip -d /var/www/html":
path=> "/usr/bin",
creates =>"/var/www/html/wordpress/index.php"
}




#wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php
# sudo cp wp-config-sample.php /var/www/html/wordpress/wp-config.php 

exec{"wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php -o wp-config.php":

path=>"/usr/bin",
cwd=> "/var/www/html/wordpress/",
creates=> "/var/www/html/wordpress/wp-config.php"
}



# sudo chmod -R 775 /var/www/html/wordpress
#sudo chown -R www-data:www-data /var/www/html/wordpress


file{'/var/www/html/wordpress':
  ensure => 'directory',
  mode   => '0775',
  owner  => 'www-data',
  group  => 'www-data',

}



# sudo service apache2 restart
exec{"systemctl restart apache2":
path=> "/bin/" 
}
