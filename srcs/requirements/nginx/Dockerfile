#FROM : Witch OS to run
FROM alpine:3.19

# Update alpine, install nginx and openssl
RUN apk update && apk --no-cache add nginx openssl

# Create dir for ssl
# openssl req: Create a new certfi request (auto-signed)
# -x509: Certif x509 (standard for SSL/TLS)
# -nodes: Allow to create a private key without password
# -days 365: certif validate time
# -newkey rsa:2048: Generate a new RSA key pair (size 2048 bits)
# -keyout: Where the key will be store
# -out: Where the certif will be store
# -subj: Info for certif SSL
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=Student/CN=tmaillar.42.fr/UID=tmaillar"

# Copy nginx custom configuration
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 443

# Launch nginx server, on daemon off, nginx must be on foreground
CMD ["nginx", "-g", "daemon off;"]
