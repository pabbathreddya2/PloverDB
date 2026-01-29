FROM tiangolo/uwsgi-nginx-flask:python3.11

RUN echo "uwsgi_read_timeout 600;" > /etc/nginx/conf.d/custom_timeout.conf

# ENV UWSGI_CHEAPER 8
# ENV UWSGI_PROCESSES 16

COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

RUN apt-get update && apt-get install -y ca-certificates

RUN mkdir -p /home/nobody
ENV HOME=/home/nobody
COPY --chown=nobody:nogroup ./.git /home/nobody/.git
COPY --chown=nobody:nogroup ./app /app

RUN touch /var/log/ploverdb.log
RUN chown nobody /var/log/ploverdb.log

RUN touch /var/log/uwsgi.log
RUN chown nobody /var/log/uwsgi.log

# Copy your corrected uwsgi.ini to replace the base image's default config
RUN cp /app/uwsgi.ini /etc/uwsgi/uwsgi.ini

RUN python /app/app/build_indexes.py