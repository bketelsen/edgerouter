FROM python:2.7.9

# Install Haproxy.
RUN \
  apt-get update && \
  apt-get install -y haproxy=1.5.8-3 supervisord && \
  sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy && \
  rm -rf /var/lib/apt/lists/*

# Install Edgerouter deps
RUN pip install requests==2.7.0

# Add files.
ADD edgerouter.py /usr/bin/edgerouter.py
ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD start.bash /haproxy-start
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Define mountable directories.
VOLUME ["/haproxy-override"]

# Define working directory.
WORKDIR /etc/haproxy

# Define default command.
CMD ["/usr/bin/supervisord"]

# Expose ports.
EXPOSE 80
EXPOSE 443
