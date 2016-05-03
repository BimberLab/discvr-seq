# DOCKER-VERSION 1.0.0
#
# The base Dockerfile for DISCVR-Seq Servers.  This will install various sequence tools used by the pipelines
#

from phusion/baseimage
maintainer bbimber@gmail.com

# these will vary by LabKey version:
ENV TC_PROJECT LabKey_DISCVR161_Installers
ENV GZ_PREFIX LabKey16.1DISCVR
ENV DIST_NAME discvr
ENV SVN_BRANCH discvr16.1
ENV LK_HOME /labkey

#
# Create directories required for running LabKey Server
#
RUN mkdir -p /labkey/
RUN mkdir -p /labkey/bin
RUN mkdir -p /labkey/svn

# Do all updates and install java in single step to slim down image
# Sequence tools are installed using a separate shell script since this config is shared by non-docker usages
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \
	apt-get -y -q install wget tar unzip subversion wget python-software-properties software-properties-common oracle-java8-installer && \
	rm -rf /var/cache/oracle-jdk8-installer && \
	svn co --username cpas --password cpas --no-auth-cache https://hedgehog.fhcrc.org/tor/stedi/branches/${SVN_BRANCH}/externalModules/labModules/SequenceAnalysis/pipeline_code ${LK_HOME}/svn/ && \
	${LK_HOME}/svn/sequence_tools_install.sh -d ${LK_HOME} -c && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	apt-get clean -y

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $LK_HOME/bin:$JAVA_HOME/bin:$PATH

