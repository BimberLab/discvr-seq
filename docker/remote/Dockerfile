# DOCKER-VERSION 1.0.0
#
# Dockerfile for remote pipeline DISCVR-Seq Servers.  This will install remote LabKey Server code in addition to various
# sequence tools used by the pipelines
#

from bbimber/discvr-seq
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
run mkdir -p /labkey/
run mkdir -p /labkey/configs

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
