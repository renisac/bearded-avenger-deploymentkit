CIF Ansible Role
=========

A complete ansible role for the Collective Intelligence Framework.

Role Variables
--------------

```
# variables
cif_version: 3.0.0b5
cif_user: cif
cif_group: cif
cif_etc_path: '/etc/cif'
cif_home: '/home/{{ cif_user }}'

smrt_enabled: true
router_enabled: true

GH_TOKEN: "{{ lookup('env', 'GH_TOKEN') }}"

# defaults
smrt:
  user: "{{ cif_user }}"
  group: "{{ cif_group }}"
  home: "{{ cif_home }}"
  runtime_path: /var/run/smrt
  cache_path: /var/run/smrt
  rules_path: /etc/cif/rules
  fireball_size: 500
  goback_days: 3
  enable_service: false
  service_client: cif

router:
  release_url: "https://github.com/csirtgadgets/bearded-avenger/archive/{{ cif_version }}.tar.gz"
  user: "{{ cif_user }}"
  group: "{{ cif_group }}"
  home: "/home/{{ cif_user }}"
  runtime_path: "/var/run/{{ cif_user }}"
  etc_path: '/etc/cif'
  config_path: "{{ cif_etc_path }}/cif-router.yml"

  httpd:
    fireball_size: 500
    listen: 127.0.0.1
    token:

  hunter:
    token:
    exclude: 'osint.bambenekconsulting.com:dga'
    threads: 2

  gatherer:
    threads: 2
    geo_fqdn: 0

geoip:
  user: 999999
  key:  "000000000000"
  products: "GeoLite2-City GeoLite2-Country GeoLite-Legacy-IPv6-City GeoLite-Legacy-IPv6-Country 506 517 533"
```

Example Playbook
----------------

all in one:

    - hosts: servers
      roles:
         - { role: csirtgadgets.cif }

router only:

    - hosts: servers
      roles:
         - { role: csirtgadgets.cif, smrt_enabled: False }

smrt only:

    - hosts: servers
      roles:
         - { role: csirtgadgets.cif, router_enabled: False }

License
-------

MPLv2

Author Information
------------------

Wes Young
CSIRT Gadgets
https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki
