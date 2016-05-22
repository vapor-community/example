FROM swiftdocker/swift:latest

RUN apt-get update
RUN apt-get install -y curl

ENV PATH /usr/bin:$PATH

ENV SWIFTVERSION_0503 DEVELOPMENT-SNAPSHOT-2016-05-03-a
RUN git clone https://github.com/kylef/swiftenv.git /usr/local/swiftenv
ENV SWIFTENV_ROOT /usr/local/swiftenv
ENV SWIFTENV_VERSIONS $SWIFTENV_ROOT/versions
ENV PATH $SWIFTENV_ROOT/bin:$SWIFTENV_ROOT/shims:$PATH
RUN swiftenv install $SWIFTVERSION_0503

RUN mkdir -p /vapor
WORKDIR /vapor
ADD . /vapor
RUN swift build

EXPOSE 8080

CMD .build/debug/App
