# Ubuntu desktop-only stuff. Abort if not Ubuntu desktop.
is_ubuntu_desktop || return 1

export BROWSER=google-chrome
alias manh='man -H'

alias pbcopy='xclip -i -selection clipboard'
alias pbpaste='xclip -o -selection clipboard'

# http://www.omgubuntu.co.uk/2016/06/install-steam-on-ubuntu-16-04-lts
function steam() {
  if [[ -e ~/.steam ]]; then
    command steam "$@"
  else
    LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1 /usr/$LIB/libgpg-error.so' command steam
  fi
}

################################
## Greeting
function get_time_period {
    hour=$(date +"%k")
    if [ $hour -lt 12 ]; then
        echo "Morning"
    elif [ $hour -ge 12 ] && [ $hour -lt 17 ]; then
        echo "Afternoon"
    else
        echo "Evening"
    fi
}

function user() {
  echo $USER
}

user_record="$(getent passwd $USER)"
user_gecos_field="$(echo "$user_record" | cut -d ':' -f 5)"
user_full_name="$(echo "$user_gecos_field" | cut -d ',' -f 1)"

# change greeting to me
echo "--------------------"
echo "Good $(get_time_period), $user_full_name"
echo "--------------------"

#################################
## User specific aliases and functions
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c="clear"
alias m="more"
alias phpL='find . -type f -name "*.php" -exec php -l {} \; | grep -v "No syntax errors"'
alias fixPerms="sudo find . -type d -exec chmod 0755 {} \; -or -type f -exec chmod 0644 {} \;"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias myip="ifconfig eth0 | grep inet | awk '{ print $2 }'"

#################################
## archives
extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
    *.tar.gz)    tar xvzf $1     ;;
    *.bz2)       bunzip2 $1      ;;
    *.rar)       unrar x $1      ;;
    *.gz)        gunzip $1       ;;
    *.tar)       tar xvf $1      ;;
    *.tbz2)      tar xvjf $1     ;;
    *.tgz)       tar xvzf $1     ;;
    *.zip)       unzip $1        ;;
    *.Z)         uncompress $1   ;;
    *.7z)        p7zip x $1         ;;
    *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
    else
        echo "'$1' is not a valid file!"
            fi
}
# create or decompress a file/folder
makebtar () {
	archive=`basename $(readlink -f $@)`;
	tar cjf "$archive".tar.bz2 "$archive";
}
makegtar () {
	archive=`basename $(`readlink -f $@`)`;
	tar czf "$archive".tar.gz "$archive";
}
# Create a ZIP archive of a file or folder.
makezip() { zip -r "${1%%/}.zip" "$1" ; }

#################################
## Php Composer
# download composer and install it globally
get-composer() {
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin
  echo "composer installed and alias created"
}
# make `composer` work by itself
alias composer="php /usr/bin/composer.phar"

##################################
## Apache
alias htdocs="cd /var/www/"
alias aprestart="sudo service apache2 restart"
alias apconfig="vi /etc/apache2/apache2.conf"

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

###############################
## nginx
alias ngrestart='sudo /etc/rc.d/nginx restart'


