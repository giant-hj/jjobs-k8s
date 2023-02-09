# J-Jobs
#
# Copyright (c) LG CNS and/or its affiliates. All rights reserved.

# Pull base image
# ---------------
FROM public.ecr.aws/amazonlinux/amazonlinux:2022 as base

# Maintainer
# ----------
MAINTAINER J-Jobs <j-jobs@lgcns.com>

# Environment variables
# ------------------------------------------------------------
ENV INSTALL_FILE=jjob_installer_linux_x64.sh \
    JJOBS_BASE=/engn001/jjobs \
    WORKING_DIR=/working

#Environment variables - port
# ------------------------------------------------------------
ENV MANAGER_WEB_PORT=7065 \
    SERVER_WEB_PORT=7075 \
    SERVER_TCP_PORT=17075

# Environment variables - log
# ------------------------------------------------------------
ENV LOGS_BASE=/logs001/jjobs \
    LOG_KEEP_DATE=5 \
    LOG_DELETE_YN=Y

# Environment variables - meta db
# -------------------------------------------------------------
ENV JDBC_URL=jdbc:postgresql://127.0.0.1:7432/jjobs \
    DB_TYPE=postgres \
    DB_IP=127.0.0.1 \
    DB_PORT=7432 \
    DB_USER=jjobs \
    DB_PASSWD=jjobs1234

# Environment variables - server
# -------------------------------------------------------------
ENV JJOBS_SERVER_ID=1 \
    JJOBS_SERVER_IP=127.0.0.1 \
    JJOB_SERVICE_NAME=.default.svc.cluster.local

# Environment variables - agent
# -------------------------------------------------------------
ENV AGENT_GROUP_ID=0

# Environment variables - install option
# -------------------------------------------------------------
ENV ON_BOOT=yes \
    INSTALL_KIND=F

# Install Util
# -------------------------------------------------------------
RUN yum update; yum clean all
RUN yum -y install wget
RUN yum -y install openssh-server openssh-clients
RUN yum -y install hostname
RUN yum -y install tar
RUN yum -y install ncurses
RUN yum -y install net-tools
RUN yum -y install zip
RUN yum -y install unzip
RUN yum -y install procps
RUN yum -y install telnet
RUN yum -y install passwd  #RUN mkdir /var/run/sshd
#RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

# Add User : jjobs
# -------------------------------------------------------------
#RUN groupadd jjobs
#RUN useradd jjobs -g jjobs
#RUN echo 'jjobs1234' | passwd --stdin root
#RUN echo 'jjobs1234' | passwd --stdin jjobs
RUN mkdir -p $JJOBS_BASE
RUN mkdir -p /data001/jjobs
RUN mkdir -p $LOGS_BASE
RUN mkdir -p /install
RUN mkdir -p $WORKING_DIR
#RUN chown -R jjobs:jjobs $JJOBS_BASE
#RUN chown -R jjobs:jjobs /data001
#RUN chown -R jjobs:jjobs $LOGS_BASE
#RUN chown -R jjobs:jjobs $WORKING_DIR

# kubectl
# -------------------------------------------------------------
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

# timezone setting
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Copy files needed during both installation and runtime
# -------------
COPY shell/entrypoint.sh /entrypoint.sh
COPY shell/install-jjobs.sh shell/after-install.sh $WORKING_DIR/
COPY shell/install-agent.sh $WORKING_DIR/
COPY shell/start-all.sh shell/stop-all.sh $WORKING_DIR/
COPY shell/sample-shell.sh $WORKING_DIR/
COPY installer/jjob_installer_linux_x64.sh /install/

RUN chmod ug+x $WORKING_DIR/*.sh
RUN chmod ug+x /install/*.sh
#RUN chown -R jjobs:jjobs $WORKING_DIR
#RUN chown jjobs:jjobs /entrypoint.sh

VOLUME ["/logs001/jjobs"]

#USER jjobs
WORKDIR /home/jjobs

EXPOSE 22 7065
ENTRYPOINT ["/entrypoint.sh"]
