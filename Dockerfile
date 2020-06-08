FROM centos:8
# CentOS8 systemd integration 
# https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
# https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Replacing the internal user/group (https://jtreminio.com/blog/running-docker-containers-as-current-host-user/#ok-so-what-actually-works)
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN if getent group apache ; then groupdel apache; fi && \
    groupadd -g ${GROUP_ID} apache && \
    useradd -l -u ${USER_ID} -g apache apache && \
    install -d -m 0755 -o apache -g apache /home/apache

# Install 3rd party repos, httpd ffmpeg & remi php
RUN yum update -y && \
 	dnf install epel-release dnf-utils nano -y && \
	dnf install http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y && \
	dnf install --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm -y && \
	dnf install http://rpmfind.net/linux/epel/7/x86_64/Packages/s/SDL2-2.0.10-1.el7.x86_64.rpm -y && \
	dnf config-manager --set-enabled PowerTools && \
	dnf install httpd httpd-tools ffmpeg -y && \
	# Fix SSL (Temp)
	dnf remove mod_ssl -y && \
	dnf module enable php:remi-7.4 -y && \
	systemctl enable httpd && \
	dnf clean all

# Install php extentions
RUN dnf install -y php php-bcmath php-cli php-common php-mbstring php-mcrypt \
	php-mysqlnd php-gd php-dom php-pecl-imagick php-pear php-intl php-ldap && \
    dnf clean all

# Update Apache / MPM Configuration
COPY ./00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf
COPY ./httpd.conf /etc/httpd/conf/httpd.conf
# RUN sed -E -i -e '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
# RUN sed -E -i -e 's/DirectoryIndex (.*)$/DirectoryIndex index.php \1/g' /etc/httpd/conf/httpd.conf

# Creat missing Apache DIR and set proper permissions
RUN mkdir -p /var/log/httpd && \
	chmod 700 /var/log/httpd/

# Remove & replace default webroot dir
RUN rm -rf /var/www/html && \
	mkdir /var/www/web

# CMS requirements check script
COPY ./check /var/www/web/check

# DocumentRoot Permissions
RUN chown -Rf apache:apache /var/www

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/init"]