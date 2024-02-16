FROM ubuntu:22.04

# Set the environment variables
ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME_NON_ROOT
ARG PASSWORD_NON_ROOT

# Update and install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    sudo \
    wget \
    software-properties-common \
    default-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and switch to it

#download
RUN wget https://cdn.downloads.dataiku.com/public/dss/11.3.2/dataiku-dss-11.3.2.tar.gz
#unpack
RUN tar xzf dataiku-dss-11.3.2.tar.gz
#install required dependencies
RUN sudo -i "/dataiku-dss-11.3.2/scripts/install/install-deps.sh" -without-java -yes

#add non root user
RUN useradd -m ${USERNAME_NON_ROOT} && echo "${USERNAME_NON_ROOT}:${PASSWORD_NON_ROOT}" | chpasswd && adduser ${USERNAME_NON_ROOT} sudo

USER ${USERNAME_NON_ROOT}

#INSTALL
RUN ./dataiku-dss-11.3.2/installer.sh -d /home/dataiku/dss -p 11000

# Define the working directory
WORKDIR /home/dataiku/dss

# Expose the port
EXPOSE 11000

# Start the DSS
CMD ["./bin/dss", "run"]
