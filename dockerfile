FROM ubuntu:20.04

ENV TZ=America/Phoenix



RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt upgrade -y && \
    apt install vim python3 python3-pip wget software-properties-common git ssh -y
RUN apt install --reinstall systemd

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
RUN dpkg -i /tmp/packages-microsoft-prod.deb
RUN rm /tmp/packages-microsoft-prod.deb

RUN apt update; \
    apt install -y apt-transport-https && \
    apt update && \
    apt install -y dotnet-sdk-5.0

RUN wget https://packages.microsoft.com/keys/microsoft.asc -O /tmp/microsoft.asc
RUN apt-key add /tmp/microsoft.asc
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list -O /tmp/mssql-server-2019.list
RUN cp /tmp/mssql-server-2019.list /etc/apt/sources.list.d/
RUN apt update
RUN apt install mssql-server -y
RUN ACCEPT_EULA=Y apt install mssql-tools unixodbc-dev -y

RUN /opt/mssql/bin/mssql-conf set sqlagent.enabled true
RUN /opt/mssql/bin/mssql-conf set telemetry.customerfeedback false

EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 1433
EXPOSE 5000
EXPOSE 5001
EXPOSE 5002
EXPOSE 5003

RUN echo 'export PATH="$PATH:/opt/mssql/bin"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"


#CMD ["/opt/mssql/bin/sqlservr"]
ENTRYPOINT [ "/opt/mssql/bin/sqlservr"]