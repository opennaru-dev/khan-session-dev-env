FROM ljhiyh/centos65

# Maintainer
# # ----------
MAINTAINER Jooho Lee <ljhiyh@gmail.com>
# Environment variables required for this build (do NOT change)
RUN yum install -y wget
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install -y git
RUN yum install -y apache-maven


EXPOSE 22 8080 9990 9999
CMD ["/bin/bash"]
