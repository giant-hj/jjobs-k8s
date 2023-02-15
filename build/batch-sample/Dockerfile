# J-Jobs 
#
# Copyright (c) LG CNS and/or its affiliates. All rights reserved.

# Pull base image
# ---------------
FROM public.ecr.aws/amazonlinux/amazonlinux:2022 as base

# Maintainer
# ----------
MAINTAINER J-Jobs <j-jobs@lgcns.com>

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------

# Custom Environment variables
# -------------------------------------------------------------
ENV WORKING_DIR=/working

# Install Util
# -------------------------------------------------------------
RUN yum update; yum clean all    
RUN yum -y install openssh-server openssh-clients
RUN yum -y install hostname
RUN yum -y install tar
RUN yum -y install ncurses
RUN yum -y install net-tools
RUN yum -y install zip
RUN yum -y install unzip
RUN yum -y install procps
RUN yum -y install telnet
RUN yum -y install passwd

RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

# Add User : jjobs
# -------------------------------------------------------------
RUN groupadd jjobs
RUN useradd jjobs -g jjobs
RUN echo 'jjobs1234' | passwd --stdin root
RUN echo 'jjobs1234' | passwd --stdin jjobs
RUN mkdir -p /engn001/jjobs
RUN mkdir -p /logs001/jjobs
RUN mkdir -p $WORKING_DIR
RUN chown -R jjobs:jjobs /engn001
RUN chown -R jjobs:jjobs /logs001
RUN chown -R jjobs:jjobs $WORKING_DIR


# Copy files needed during both installation and runtime
# -------------
COPY shell/entrypoint.sh /entrypoint.sh
COPY shell/test-case1.sh shell/test-case2.sh $WORKING_DIR/

RUN chmod ug+x $WORKING_DIR/*.sh

# timezone setting
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

VOLUME ["/logs001/jjobs"]

USER jjobs

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]

