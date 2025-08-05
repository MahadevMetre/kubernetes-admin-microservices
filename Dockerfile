FROM nginx:alpine
COPY ./frontend-ui/ /usr/share/nginx/html
EXPOSE 80

