FROM alpine:latest

RUN apk add --no-cache unbound curl

# Копируем конфигурационные файлы
COPY unbound.conf /etc/unbound/unbound.conf
COPY root.hints /etc/unbound/root.hints

# A записи
COPY happylink.zone.conf /etc/unbound/happylink.zone.conf
COPY blacklist.conf /etc/unbound/blacklist.conf

# PTR записи
COPY 146-120-101.conf /etc/unbound/146-120-101.conf
COPY 193-176-2.conf /etc/unbound/193-176-2.conf

# Скрипт обновления blacklist
COPY update_blacklist.sh /usr/local/bin/update_blacklist.sh
RUN chmod +x /usr/local/bin/update_blacklist.sh

EXPOSE 5301

CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]
