FROM alpine
RUN apk add --no-cache nginx
EXPOSE 80
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]