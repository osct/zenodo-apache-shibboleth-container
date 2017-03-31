#!/bin/bash

# Apache and Shibd gets grumpy about PID files pre-existing from previous runs
rm -f /usr/local/apache2/logs/httpd.pid /var/lock/subsys/shibd

# Start Shibd
/etc/shibboleth/shibd-redhat start

# Start httpd
exec httpd -DFOREGROUND
