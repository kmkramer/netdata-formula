{% from "netdata/map.jinja" import netcat with context %}

{% if salt['grains.get']('netdata') != 'installed' %}

netdata_packages:
  pkg.installed:
    - pkgs:
      - autoconf
      - automake
      - curl
      - gcc
      - git
      - libmnl-devel
      - libuuid-devel
      - lm_sensors
      - make
      - MySQL-python
      - pkgconfig
      - python
      - python-psycopg2
      - PyYAML
      - zlib-devel
      - {{ netcat.pkg }}

netdata_git:
  git.latest:
    - name: https://github.com/firehol/netdata.git
    - depth: 1
    - target: /tmp/netdata

netdata_install:
  cmd.run:
    - name: /tmp/netdata/netdata-installer.sh --dont-start-it --dont-wait
    - cwd: /tmp/netdata
  grains.present:
    - name: netdata
    - value: installed

/tmp/netdata:
  file.absent:
    - order: last
    
{% endif %}
