FROM nextcloud:apache

COPY rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \

    # Update apt-cache
    apt-get update && \

	# Install cron
	apt-get install -y --no-install-recommends \
		cron && \

	# Configure cron
	echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\"" | crontab - && \

	# Install supervisord
	apt-get install -y --no-install-recommends \
		-o Dpkg::Options::="--force-confdef" \
		-o Dpkg::Options::="--force-confold" \
		supervisor && \

	# Configure supervisord
	mkdir -p /var/log/supervisord && \
	mkdir -p /var/run/supervisord && \
	rm -f /etc/supervisor/supervisord.conf.dpkg-dist && \
	rmdir /etc/supervisor/conf.d && \

	# Clean apt-cache
	apt-get autoremove -y --purge && \
	apt-get autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/* \
	/var/log/*

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
