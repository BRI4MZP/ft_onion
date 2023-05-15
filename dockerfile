FROM debian:latest

RUN set -x -e  && apt-get update -y && apt-get install nginx tor openssh-server sudo vim -y

COPY sshd_config /etc/ssh/sshd_config
COPY torrc /etc/tor/torrc
COPY index.html /var/www/html/index.html
COPY config.conf /etc/nginx/nginx.conf
RUN useradd -m briveiro
RUN echo "briveiro:briveiro" | chpasswd
RUN sudo -u briveiro mkdir -p /home/briveiro/.ssh
RUN sudo -u briveiro chmod 700 /home/briveiro/.ssh

# COPY --chown=briveiro temp_pub_key.pub /home/briveiro/.ssh/authorized_keys

# RUN sudo -u briveiro chmod 600 /home/briveiro/.ssh/authorized_keys
RUN groupadd sshusers
RUN usermod -aG sshusers briveiro
RUN usermod -aG sudo briveiro
RUN rm /var/www/html/index.nginx-debian.html

ENTRYPOINT service ssh start; nginx; tor
CMD ["service tor start && service ssh start && nginx -g 'daemon off;'"]