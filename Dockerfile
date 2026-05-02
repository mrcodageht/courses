FROM python:3.13-slim AS build

WORKDIR /app
COPY ./requirements.txt .
RUN pip install -r requirements.txt
COPY . .

RUN mkdocs build

FROM nginx:stable-alpine
COPY --from=build /app/site /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]