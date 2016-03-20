#/bin/dash -x


sudo apt-get update
sudo apt-get install -y  git software-properties-common python-software-properties
sudo add-apt-repository -y ppa:brightbox/ruby-ng
sudo add-apt-repository -y ppa:chris-lea/redis-server
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y nginx php5-fpm libssl-dev git ruby2.2 rake curl wget gcc make bison libssl-dev libcurl4-openssl-dev libpcre3 libpcre3-dev libpcre++-dev libgd2-xpm-dev libgeoip-dev libxml2-dev libxslt-dev python-geoip git-core build-essential zlib1g-dev libreadline6-dev bison redis-server autoconf build-essential checkinstall 



if [ ! -d /build ]; then
sudo mkdir /build
fi

cd /build

if [ ! -d openssl-1.0.2g ]; then
curl -LO http://www.openssl.org/source/openssl-1.0.2g.tar.gz
else
rm -frv openssl*
curl -LO http://www.openssl.org/source/openssl-1.0.2g.tar.gz
fi
tar xvzf openssl-1.0.2g.tar.gz
cd openssl-1.0.2g
./config --prefix=/usr --openssldir=/usr/share/ssl shared
make -j12
make test
sudo make install
cd /build

if [ ! -d hiredis ]; then
git clone https://github.com/redis/hiredis.git
fi

cd hiredis
git gc
git pull
make -j12
sudo make install
cd /build

if [ ! -d mruby ]; then
git clone https://github.com/mruby/mruby.git
fi
cd mruby
make -j12
cd /build
if [ ! -d nginx ]; then
git clone git://github.com/nginx/nginx-releases nginx
fi


cd /build/nginx
git gc
git pull


if [ ! -d nginx-rtmp ]; then
git clone  git://github.com/arut/nginx-rtmp-module.git nginx-rtmp
fi


cd nginx-rtmp
git gc
git pull
cd /build/nginx



if [ ! -d nginx-ngx_mruby ]; then
 git clone git://github.com/matsumoto-r/ngx_mruby.git nginx-ngx_mruby
fi


cd nginx-ngx_mruby
git gc
git pull
git submodule init
git submodule update
./configure --with-ngx-src-root=/build/nginx
make build_mruby
make generate_gems_config
cd /build/nginx


if [ ! -d ngx_cache_purge ]; then
git clone git://github.com/FRiCKLE/ngx_cache_purge.git ngx_cache_purge
fi

cd ngx_cache_purge
git gc
git pull
cd /build/nginx


./configure \
 --prefix=/etc/nginx \
 --sbin-path=/usr/sbin/nginx \
 --conf-path=/etc/nginx/nginx.conf \
 --error-log-path=/var/log/nginx/error.log \
 --http-client-body-temp-path=/var/lib/nginx/body \
 --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
 --http-log-path=/var/log/nginx/access.log \
 --http-proxy-temp-path=/var/lib/nginx/proxy \
 --http-scgi-temp-path=/var/lib/nginx/scgi \
 --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
 --lock-path=/var/lock/nginx.lock \
 --pid-path=/var/run/nginx.pid \
 --with-pcre-jit \
 --with-debug \
 --with-http_addition_module \
 --with-http_dav_module \
 --with-http_geoip_module \
 --with-http_gzip_static_module \
 --with-http_image_filter_module \
 --with-http_realip_module \
 --with-http_stub_status_module \
 --with-http_ssl_module \
 --with-http_sub_module \
 --with-http_xslt_module \
 --with-ipv6 \
 --with-openssl=/build/openssl-1.0.2g \
 --with-sha1=/usr/local/include/openssl \
 --with-md5=/usr/local/include/openssl \
 --with-mail \
 --with-mail_ssl_module \
 --add-module=./nginx-ngx_mruby \
 --add-module=./nginx-ngx_mruby/dependence/ngx_devel_kit \
 --add-module=./nginx-rtmp
make -j12
sudo make install
