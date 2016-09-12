# DOCKER-VERSION 1.0.0
#
# Dockerfile for remote pipeline DISCVR-Seq Servers.  This will install remote LabKey Server code in addition to various
# sequence tools used by the pipelines
#

from bbimber/discvr-seq:16.2server
maintainer bbimber@gmail.com

# the only reason for this command is to pre-explode all the modules to save time when running the container
RUN date && cd $LK_HOME && java -cp $JAVA_HOME/lib/tools.jar:$LK_HOME/labkeyBootstrap.jar org.labkey.bootstrap.ClusterBootstrap

