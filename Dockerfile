FROM nextcloud:apache

RUN \

	export DEBIAN_FRONTEND=noninteractive && \

	# Update apt-cache && \
	apt-get update && \

	# Install cron && \
	apt-get install -y --no-install-recommends \
		cron && \

	# Install supervisord && \
	apt-get install -y --no-install-recommends \
		supervisor && \

	# Configure supervisord && \
	mkdir -p /var/log/supervisord && \
	mkdir -p /var/run/supervisord && \
	echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\"" | crontab - && \

	# Clean apt-cache && \
	apt-get autoremove -y --purge && \
	apt-get autoclean -y && \

	# Cleanup temporary folders && \
	rm -rf \
		/root/.cache \
		/root/.wget-hsts \
		/tmp/* \
		/var/lib/apt/lists/*

COPY docker.rootfs /

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
