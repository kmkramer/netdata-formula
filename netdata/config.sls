include:
  - netdata

/etc/init.d/netdata:
  file.managed:
    - source: salt://netdata/files/netdata-init.d
    - mode: 755

netdata:
  service.running:
    - enable: True
    - watch:
      - file: /etc/netdata/netdata.conf

/etc/netdata/netdata.conf:
  file.managed:
    - source: salt://netdata/files/netdata.conf
    - template: jinja
