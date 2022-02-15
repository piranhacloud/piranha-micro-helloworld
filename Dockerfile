#
# Build the WAR file
#
FROM eclipse-temurin:17 AS builder
RUN cd /usr/local && \
    curl -O https://archive.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz && \
    tar xfvz apache-maven-3.8.4-bin.tar.gz && \
    rm apache-maven-3.8.4-bin.tar.gz
COPY . /root
RUN export PATH=$PATH:/usr/local/apache-maven-3.8.4/bin && \
    cd /root && \
    mvn --no-transfer-progress clean install

#
# Deploy the WAR file.
#
FROM piranhacloud/micro:v22.2.0
COPY --from=builder /root/target/piranha-micro-helloworld.war /usr/local/piranha/ROOT.war
EXPOSE 8080
CMD ["java", "-jar", "piranha-micro.jar", "--war-file", "ROOT.war"]
