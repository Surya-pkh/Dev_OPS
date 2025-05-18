FROM nginx:latest

# Remove default config and add our custom config
RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d/

# Replace the default html directory
COPY html/ /usr/share/nginx/html/

# Expose port
EXPOSE 80
