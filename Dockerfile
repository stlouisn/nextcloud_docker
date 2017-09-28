FROM nextcloud:apache

RUN \

	export DEBIAN_FRONTEND=noninteractive && \

	# Update apt-cache && \
	apt-get update && \

	# Enable apache2 servername.conf
	touch /etc/apache2/conf-available/servername.conf && \
	a2enconf servername && \

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

COPY supervisor.conf /etc/supervisor/supervisor.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisor.conf"]
