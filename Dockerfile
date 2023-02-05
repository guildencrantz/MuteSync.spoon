FROM python:3.11-buster

RUN git clone https://github.com/Hammerspoon/hammerspoon.git /hammerspoon

WORKDIR /hammerspoon

RUN pip install -r requirements.txt

VOLUME /wd

WORKDIR /wd

CMD [ "python3", "/hammerspoon/scripts/docs/bin/build_docs.py", "--templates", "/hammerspoon/scripts/docs/templates", "--json", "--html", "--markdown", "--standalone", "--output_dir", "docs/", "." ]
