FROM python:alpine
WORKDIR /docs

RUN pip install mkdocs mkdocs-material mkdocs-render-swagger-plugin mkdocs-mermaid2-plugin
COPY ./docs /docs
COPY ./api /api
RUN mkdocs build

FROM nginx:alpine
COPY --from=0 ./docs/site/ /usr/share/nginx/html/
