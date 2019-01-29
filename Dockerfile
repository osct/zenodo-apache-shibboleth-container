FROM centos:centos7

LABEL maintainer="INFN"

ENV LANG en_US.UTF-8

RUN yum -y update \
    && yum -y install wget \
    && wget http://download.opensuse.org/repositories/security://shibboleth/CentOS_7/security:shibboleth.repo -P /etc/yum.repos.d \
    && yum -y install httpd shibboleth-3.0.3-1.1 mod_ssl mod_wsgi \
    && yum -y install centos-release-scl \
    && yum -y install rh-python36 \
    && yum -y install git \
    && yum -y install gcc gcc-c++ libffi-devel cairo cairo-devel \
    && yum -y install rh-nodejs8-npm rh-nodejs8-nodejs \
    && yum -y clean all

COPY httpd-shibd-foreground /usr/local/bin/
COPY httpd/conf.d /etc/httpd/
COPY shibboleth/ /etc/shibboleth/
COPY zenodo/ /opt/zenodo/
COPY zenodo-extras/ /opt/zenodo/

RUN test -d /var/run/lock || mkdir -p /var/run/lock \
    && test -d /var/lock/subsys/ || mkdir -p /var/lock/subsys/ \
    && echo $'export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH\n'\
       > /etc/sysconfig/shibd \
    && chmod +x /etc/sysconfig/shibd /etc/shibboleth/shibd-redhat /usr/local/bin/httpd-shibd-foreground \
    && sed -i 's/ErrorLog "logs\/error_log"/ErrorLog \/dev\/stdout/g' /etc/httpd/conf/httpd.conf \
    && echo -e "\nErrorLogFormat \"httpd-error [%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\ %a] %M% ,\ referer\ %{Referer}i\"" >> /etc/httpd/conf/httpd.conf \
    && sed -i 's/CustomLog "logs\/access_log" combined/CustomLog \/dev\/stdout \"httpd-combined %h %l %u %t \\\"%r\\\" %>s %b \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\"\"/g' /etc/httpd/conf/httpd.conf \
    && sed -i 's/ErrorLog logs\/ssl_error_log/ErrorLog \/dev\/stdout/g' /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/<\/VirtualHost>/ErrorLogFormat \"httpd-ssl-error [%{u}t] [%-m:%l] [pid %P:tid %T] %7F: %E: [client\\ %a] %M% ,\\ referer\\ %{Referer}i\"\n<\/VirtualHost>/g' /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/CustomLog logs\/ssl_request_log/CustomLog \/dev\/stdout/g' /etc/httpd/conf.d/ssl.conf \
    && sed -i 's/TransferLog logs\/ssl_access_log/TransferLog \/dev\/stdout/g' /etc/httpd/conf.d/ssl.conf

RUN cd /opt \
    && /opt/rh/rh-python36/root/usr/bin/python -m venv zenodo_venv \
    && source zenodo_venv/bin/activate \
    && cd zenodo \
    && pip install --upgrade pip \
    && pip install -r requirements.txt --src ~/src/ --pre --upgrade 

RUN cd /opt \ 
    && source zenodo_venv/bin/activate \
    && cd zenodo \
    && pip install -e .[all,postgresql,elasticsearch2]

RUN source /opt/rh/rh-nodejs8/enable \
    && source /opt/zenodo_venv/bin/activate \
    && cd /opt/zenodo \
    && ./scripts/setup-npm.sh 
#    && ./scripts/setup-assets.sh

 
EXPOSE 80 443

CMD ["httpd-shibd-foreground"]
