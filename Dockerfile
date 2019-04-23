FROM nextcloud:apache

COPY rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \

    # Update apt-cache
    apt-get update && \

	# Install tzdata
    apt-get install -y --no-install-recommends \
        tzdata && \

    # Install gosu
    apt-get install -y --no-install-recommends \
        gosu && \

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
        /var/lib/apt/lists/*

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
