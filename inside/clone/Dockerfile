FROM --platform=linux/amd64 ubuntu:latest
WORKDIR /app

# Install basic CLI tools
RUN apt-get update -y && apt-get install -y \
                         gnupg \
                         wget \
                         git \
                         openssh-client

# Install DVC
RUN wget \
       https://dvc.org/deb/dvc.list \
       -O /etc/apt/sources.list.d/dvc.list
RUN wget -qO - https://dvc.org/deb/iterative.asc | gpg --dearmor > packages.iterative.gpg
RUN install -o root -g root -m 644 packages.iterative.gpg /etc/apt/trusted.gpg.d/
RUN rm -f packages.iterative.gpg
RUN apt update -y && apt install -y dvc

COPY entry.sh .
RUN chmod +x entry.sh

CMD ["./entry.sh"]

