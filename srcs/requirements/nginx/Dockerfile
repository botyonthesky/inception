FROM alpine:3.19

RUN apk update && apk --no-cache add nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=Student/CN=tmaillar.42.fr/UID=tmaillar"

COPY /conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

#EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
