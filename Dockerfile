# DOCKER-VERSION 1.0.0
#
# Dockerfile for remote pipeline DISCVR-Seq Servers.  This will install remote LabKey Server code and various
# sequence tools used by the pipelines
#

from ubuntu:14.04
maintainer bbimber@gmail.com

# these will vary by LabKey version:
ENV BRANCH LabkeyDISCVR152_Installers
ENV GZ_PREFIX LabKey15.2DISCVR
ENV DIST_NAME onprc
ENV SVN_BRANCH discvr15.2

ENV LK_HOME /labkey

# Update the Ubuntu and install required tools
RUN (apt-get update; \
     apt-get -y -q install wget tar unzip subversion wget python-software-properties software-properties-common; \
     apt-get clean -y)

# Install Java
RUN (echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java7-installer && \
    rm -rf /var/cache/oracle-jdk7-installer)

#rm -rf /var/lib/apt/lists/* && \

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV PATH $PATH:$JAVA_HOME/bin

#
# Create directories required for running LabKey Server
#
run mkdir -p /labkey/
run mkdir -p /labkey/bin
run mkdir -p /labkey/configs
run mkdir -p /labkey/svn

# download latest build
RUN wget -r --trust-server-names --no-check-certificate http://teamcity.labkey.org/guestAuth/repository/download/${BRANCH}/.lastSuccessful/${DIST_NAME}/${GZ_PREFIX}-{build.number}-${DIST_NAME}-bin.tar.gz
RUN mv ./teamcity.labkey.org/guestAuth/repository/download/${BRANCH}/.lastSuccessful/onprc/*.gz ./
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

#this is a hack for now.  eventually this script should be merged into the dockerfile
#RUN svn co --username cpas --password cpas --no-auth-cache https://hedgehog.fhcrc.org/tor/stedi/branches/${SVN_BRANCH}/externalModules/labModules/SequenceAnalysis/pipeline_code /labkey/svn/trunk/pipeline_code/
RUN svn co --username cpas --password cpas --no-auth-cache https://hedgehog.fhcrc.org/tor/stedi/trunk/externalModules/labModules/SequenceAnalysis/pipeline_code /labkey/svn/trunk/pipeline_code/
RUN ${LK_HOME}/svn/trunk/pipeline_code/sequence_tools_install.sh -d ${LK_HOME}

#note: need to sort out users/permissions
#-u labkey
#chown -R labkey:labkey $LK_HOME
