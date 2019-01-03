
##################################
## Apache
alias htdocs="cd /var/www/"
alias restart-server="sudo service apache2 restart"
alias apache-config="vi /etc/apache2/apache2.conf"

create-site-conf() {
    OLD="example.com"
    echo "Enter the name of the new site:"
    read SITENAME
    cat ~/.vhost.conf > "$SITENAME.conf"
    sed "s/$OLD/$SITENAME/g" "$SITENAME.conf"
    echo "created $SITENAME.conf"
}

# create a new git enabled project
new-project() {
  #where are we starting from?
  LOCATION="$(pwd)"
  # get the sitename
  SITENAME="$1"
  # setup the directories
  mkdir -p /var/www/html/$SITENAME # && cd /var/www/html/$SITENAME
  mkdir -p /var/www/git/$SITENAME.git && cd /var/www/git/$SITENAME.git
  git init --bare && cd hooks
  # create post-receive file and own it
  echo "git --work-tree=/var/www/html/$SITENAME --git-dir=/var/www/git/$SITENAME.git checkout -f" > post-receive
  chmod +x post-receive
  # go back to where we started
  cd $LOCATION
  # get the IP for this server
  IP="$(curl -sS http://myip.dnsomatic.com)"
  # tell us how to clone this repo, we assume the username is the default `root`
  echo "git remote add dev ssh://root@$IP:/var/www/git/$SITENAME.git"
}

apache-setup() {
  a2enmod rewrite expires mime headers deflate filter file_cache cache cache_disk cache_socache mime setenvif
}
