FROM alpine:edge

ENV SSH_USER="myuser"

RUN apk update && apk add bash && apk add openssh


RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "AllowUsers ${SSH_USER}" >> /etc/ssh/sshd_config

RUN ssh-keygen -A && adduser -D -g ${SSH_USER} -h /home/${SSH_USER} -s /bin/bash ${SSH_USER} && mkdir -p /var/run/sshd
COPY mykeys.pub /home/${SSH_USER}/.ssh/authorized_keys
#RUN chmod 0700 /home/${SSH_USER}/.ssh \
#    && chmod 0600 /home/${SSH_USER}/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]