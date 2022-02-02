FROM openjdk:11-jre-slim

ENV TECHNISYS_HOME /home

RUN apt-get update && apt-get install -y curl && apt-get clean 

RUN groupadd -r technisys && \
    useradd -g technisys -d $TECHNISYS_HOME -s /sbin/nologin -c "Technisys user" technisys && \
    chown -R technisys:technisys $TECHNISYS_HOME

USER technisys

WORKDIR $TECHNISYS_HOME

ENTRYPOINT sh start.sh

ARG curl_opts
ENV platform_artifact_name='apicatalog'
ARG platform_artifact_version='1.0.5'
ENV artifact_url="https://artifactory.technisys.com/artifactory/libs-release/com/technisys/cyberbank/platform/$platform_artifact_name/$platform_artifact_version/$platform_artifact_name-$platform_artifact_version.jar"
ARG artifact_sha1='0392260c886b91fc616ff042b638bc171310d7b1'

RUN curl $curl_opts -o $platform_artifact_name.jar $artifact_url && \
    sha1sum $platform_artifact_name.jar | grep $artifact_sha1 && \
    mkdir assets


ENV DEBUG_MODE=false

ENV OPENTRACING_JAEGER_ENABLED="false"

ENV OPENTRACING_JAEGER_SERVICE-NAME="apicatalog"
