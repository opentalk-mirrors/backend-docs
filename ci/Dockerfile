FROM python:alpine
WORKDIR /docs

RUN pip install mkdocs mkdocs-material
COPY ./docs /docs
RUN mkdocs build

FROM nginx:alpine
COPY --from=0 ./docs/site/ /usr/share/nginx/html/
