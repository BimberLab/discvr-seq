# DOCKER-VERSION 1.0.0
#
# Dockerfile for remote pipeline DISCVR-Seq Servers.  This will install remote LabKey Server code in addition to various
# sequence tools used by the pipelines
#

from bbimber/discvr-seq:16.2
maintainer bbimber@gmail.com

# these will vary by LabKey version:
ENV TC_PROJECT LabKey_DISCVR162_Installers
ENV GZ_PREFIX LabKey16.2DISCVR
ENV DIST_NAME discvr
ENV SVN_BRANCH discvr16.2
ENV LK_HOME /labkey

#
# This creates a container intended to run as a remote pipeline server.  You must provide the config files,
# which should at minimum include a pipelineConfig.xml file.  You will likely also need to mount the 
# shared folder where you data resides and consider setting an activemq host entry.  However, these are all
# configured via pipelineConfig.xml so you do have flexibility.
# 
# Example Command:
# 
# docker run --rm -v /<PATH_TO_LK_CONFIG>:/labkey/configs -v /<PATH_TO_DATA_DIR>:/labkey_data bbimber/discvr-seq:<SERVER_VERSION> <COMMAND_TO_RUN>
# 
# Consider adding --add-host activemq:XXX.XXX.XXX.XXX, depending on how pipelineConfig.xml is set up
# 

run mkdir -p /labkey/ && mkdir -p /labkey/configs && mkdir -p /labkey/logs

# download latest build
RUN wget -r --trust-server-names --no-check-certificate http://teamcity.labkey.org/guestAuth/repository/download/${TC_PROJECT}/.lastSuccessful/${DIST_NAME}/${GZ_PREFIX}-{build.number}-${DIST_NAME}-bin.tar.gz && \
	mv ./teamcity.labkey.org/guestAuth/repository/download/${TC_PROJECT}/.lastSuccessful/${DIST_NAME}/*.gz ./ && \
	rm -Rf ./teamcity.labkey.org && \
	GZ=$(ls -tr | grep '^LabKey.*\.gz$' | tail -n -1) && \
	tar -xf $GZ && \
	DIR=$(echo $GZ | sed -e "s/.tar.gz$//") && \
	cp -R ${DIR}/bin $LK_HOME && \
	cp -R ${DIR}/modules $LK_HOME && \
	cp -R ${DIR}/labkeywebapp $LK_HOME && \
	cp -R ${DIR}/pipeline-lib $LK_HOME && \
	cp -R ${DIR}/tomcat-lib/labkeyBootstrap.jar $LK_HOME && \
	mkdir -p /labkey/apps/tomcat/lib/ && \
	cp -f ${DIR}/tomcat-lib/*.jar /labkey/apps/tomcat/lib/ && \
	cd $LK_HOME && \
	rm -rf ${DIR} && \
	rm -Rf $GZ

