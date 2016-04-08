# DOCKER-VERSION 1.0.0
#
# Dockerfile for remote pipeline DISCVR-Seq Servers.  This will install remote LabKey Server code and various
# sequence tools used by the pipelines
#

from phusion/baseimage
maintainer bbimber@gmail.com

# these will vary by LabKey version:
ENV TC_PROJECT LabKey_LabkeyDISCVR153_Installers
ENV GZ_PREFIX LabKey15.3DISCVR
ENV DIST_NAME discvr
ENV SVN_BRANCH discvr15.3

#using revision is a cheap way to force the Dockerfile to increment when the shell script changes.  eventually that script should be more tightly integrated with docker.
#ENV SVN_REVISION 41330

ENV LK_HOME /labkey

# Update the Ubuntu and install required tools
RUN (apt-get update; \
     apt-get -y -q install wget tar unzip subversion wget python-software-properties software-properties-common; \
     apt-get clean -y)

# Install Java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \
	apt-get install -y oracle-java8-installer && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer

#rm -rf /var/lib/apt/lists/* && \

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin

#
# Create directories required for running LabKey Server
#
run mkdir -p /labkey/
run mkdir -p /labkey/bin
run mkdir -p /labkey/configs
run mkdir -p /labkey/svn

# download latest build
RUN wget -r --trust-server-names --no-check-certificate http://teamcity.labkey.org/guestAuth/repository/download/${TC_PROJECT}/.lastSuccessful/${DIST_NAME}/${GZ_PREFIX}-{build.number}-${DIST_NAME}-bin.tar.gz
RUN mv ./teamcity.labkey.org/guestAuth/repository/download/${TC_PROJECT}/.lastSuccessful/${DIST_NAME}/*.gz ./
RUN rm -Rf ./teamcity.labkey.org

RUN (GZ=$(ls -tr | grep '^LabKey.*\.gz$' | tail -n -1); \
     tar -xf $GZ; \
     DIR=$(echo $GZ | sed -e "s/.tar.gz$//"); \
     cp -R ${DIR}/bin $LK_HOME; \
     cp -R ${DIR}/modules $LK_HOME; \
     cp -R ${DIR}/labkeywebapp $LK_HOME; \
     cp -R ${DIR}/pipeline-lib $LK_HOME; \
     mkdir -p /labkey/apps/tomcat/lib/; \
     cp -f ${DIR}/tomcat-lib/*.jar /labkey/apps/tomcat/lib/; \
     rm -rf ${DIR})

#TODO: bootstrap JAR?

#-r SVN_REVISION
RUN svn co --username cpas --password cpas --no-auth-cache https://hedgehog.fhcrc.org/tor/stedi/branches/${SVN_BRANCH}/externalModules/labModules/SequenceAnalysis/pipeline_code ${LK_HOME}/svn/
RUN ${LK_HOME}/svn/sequence_tools_install.sh -d ${LK_HOME}

#note: need to sort out users/permissions
#-u labkey
#chown -R labkey:labkey $LK_HOME


