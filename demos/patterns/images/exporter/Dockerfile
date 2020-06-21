# // based on: k8spatterns.io
FROM perl

ENV LOG_FILE=/logs/generator.log

RUN cpanm install Net::Server::HTTP Text::CSV

EXPOSE 9898

COPY exporter.pl /
CMD perl /exporter.pl