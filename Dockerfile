  FROM ubuntu:latest
  
  RUN apt-get update && \
      apt-get install -y ca-certificates tzdata wget tar curl
  
  WORKDIR /app
  COPY . .
  RUN chmod -R 777 /app 
  

  RUN --mount=type=secret,id=gist_teldrive,mode=0444,required=true \
      wget https://github.com/divyam234/teldrive/releases/download/1.4.9/teldrive-1.4.9-linux-amd64.tar.gz -O /app/teldrive.tar.gz && \
      tar xvf /app/teldrive.tar.gz -C /app  && \
      wget $(cat /run/secrets/gist_teldrive) -O /app/config.toml && \
      chmod a+x /app/teldrive && chmod 777 /app/config.toml  && \
      touch /app/session.db && \
      chmod 777 /app/session.db
  
  RUN chmod a+x /app/start.sh
  
  CMD ["./start.sh"]