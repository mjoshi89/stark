Dockerfile -->If you want to create a docker centos:6 image with python2.7, mongoDB, Java and Tomcat 7 installed.
              docker build -t <imagename>:<version> .
              docker run -d -p 8070:8080 --name <container_name> <imagename>:<version>

parallelssh --> Use this script to connect to multiple instances(passed as comma separated argument, -s <server1>, <server2>).
                You can also provide how many servers you want to cnnect at once by -p parameter, -p 5
                Once you execute this script it'll ask for what command you want to execute in all the hosts.
                You can set the log directory to save the logs for later.

MigrateDoc --> This doc helps us understand what are the broad steps to be taken to migrte a monolithic Java application from
                on-premse to AWS cloud.
