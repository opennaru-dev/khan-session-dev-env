FROM ljhiyh/centos65

# Maintainer
# # ----------
MAINTAINER Jooho Lee <ljhiyh@gmail.com>
# Environment variables required for this build (do NOT change)

# Set the WILDFLY_SERVER_HOME env variable
ENV HOME /home/jhouse
# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 8.1.0.Final
# Set the WILDFLY_PKG env variable
ENV WILDFLY_PKG  wildfly-$WILDFLY_VERSION.zip
# Set JAVA_HOME env variable
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.65.x86_64
# Set CONFIG_JVM_ARGS env variable(it is for linux bug)
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom
# Set ROOT_PW env variable
ENV ROOT_PW redhat
# Set WILDFLY_PW env variable
ENV WILDFLY_PW wildfly

# Upload default environment which can be known after container start up
ADD bashrc  /home/bashrc
RUN cat /home/bashrc >> /etc/profile

#Create root/jboss user and default directories
RUN echo root:$ROOT_PW | chpasswd

RUN mkdir -p $HOME  && chmod a+xr $HOME && \
    useradd -b $HOME -m -s /bin/bash jboss && \
    echo jboss:$WILDFLY_PW | chpasswd


# Upload and unzip Infinispan server
ADD wildfly-$WILDFLY_VERSION.zip $HOME/
RUN unzip -q $HOME/$WILDFLY_PKG -d $HOME && \
    mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly

WORKDIR $HOME/wildfly
RUN bin/add-user.sh -s jboss 7ujm*ik,
USER root
EXPOSE 22 8080 9990 9999
CMD ["/bin/bash"]
