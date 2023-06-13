FROM ubuntu:latest
WORKDIR /app
COPY test.sh .
RUN  chmod +x test.sh
CMD ["./test.sh"]

