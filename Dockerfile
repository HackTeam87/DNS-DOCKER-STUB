# Используем легковесный базовый образ Python
FROM python:3.11-slim

# Устанавливаем зависимости для Unbound, Python и unbound-host logrotate net-tools iputils-ping lsof 
RUN apt-get update && apt-get install -y \
    unbound \
    curl \
    dnsutils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Копируем конфигурационные файлы и ключи для Unbound
COPY unbound/ /etc/unbound/

# Создаем директорию для логов и даем права
RUN mkdir -p /var/log/unbound && chown unbound:unbound /var/log/unbound

# Копируем конфигурацию для logrotate
#COPY logrotate/unbound /etc/logrotate.d/unbound
#RUN echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.conf" >> /etc/crontab

# Настраиваем rsyslog для отправки логов в Graylog
# COPY rsyslog/graylog.conf /etc/rsyslog.conf

# Создайте пользователя и группу syslog, если они не существуют
# RUN groupadd -r syslog && useradd -r -g syslog syslog

# Создайте нужную директорию для rsyslog
#RUN mkdir -p /var/spool/rsyslog && \
 #   chown syslog:syslog /var/spool/rsyslog && \
  #  chmod 755 /var/spool/rsyslog
   
# Запускаем rsyslog
#RUN echo "module(load='imudp')\ninput(type='imudp' port='514')" > /etc/rsyslog.conf

# Открываем порты
EXPOSE 53

# Команда для запуска Unbound, rsyslog и Python-скрипта
#CMD sh -c "rsyslogd && unbound -d -c /etc/unbound/unbound.conf"
CMD sh -c "unbound -d -c /etc/unbound/unbound.conf"
