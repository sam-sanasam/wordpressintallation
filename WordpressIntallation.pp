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
user{"mysqladmin":                                                                                                 
ensure=> present,                                                                                                  
password=> Sensitive ("rootpassword")                                                                              
}                                                                                                                  
                                                                                                                   
                                                                                                                   
# wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands      
                                                                                                                   
                                                                                                                   
package{"wget":                                                                                                    
ensure=> present,                                                                                                  
}   

exec{"wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands":
path=> "/usr/bin",
cwd=> "/tmp",
}

#mysql -uroot -prootpassword < /tmp/mysqlcommands





#wget https://wordpress.org/latest.zip

exec{"wget https://wordpress.org/latest.zip":
path=> "/usr/bin",
cwd=> "/tmp",
}

#sudo apt install -y unzip
package{"unzip":
ensure=>present,
}



#sudo unzip /tmp/latest.zip -d /var/www/html
exec{"unzip /tmp/latest.zip -y":
path=> "/usr/bin",
#command=>" /tmp/latest.zip"
cwd=> "/var/www/html"
}




#wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php
# sudo cp wp-config-sample.php /var/www/html/wordpress/wp-config.php 
exec{"wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php":
#command=>"https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php",
path=>"/usr/bin",
cwd=> "/var/www/html/wordpress"
}

# sudo chmod -R 775 /var/www/html/wordpress

exec{"chmod -R 775 /var/www/html/wordpress":
path=>"/bin",
#command=> "chmod -R 775",
#cwd=> "/var/www/html/wordpress"
}

#sudo chown -R www-data:www-data /var/www/html/wordpress
exec{"chown -R www-data:www-data /var/www/html/wordpress":
path=>"/bin",
#command=> "chown -R www-data:www-data",
#cwd=> "/var/www/html/wordpress"
}

# sudo service apache2 restart


service{"apache":
ensure=> "running",
restart=> "restart",
}