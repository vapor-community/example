FROM swiftdocker/swift@sha256:c87f5a55a83ad2a8132b23b4faed6e1114f86bac0153a87e28f038b831339872

ENV PATH /usr/bin:$PATH

RUN mkdir -p /vapor
WORKDIR /vapor
ADD . /vapor
RUN swift build

EXPOSE 8080

CMD .build/debug/App
