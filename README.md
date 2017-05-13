mvitale1989.inventory-hosts
=========

Ansible role to automatically add every inventory host to a host's `/etc/hosts`. Managed lines will co-exist with any manual configuration.

This role works out-of-the-box: if you want to populate one host's `/etc/hosts` with all the hosts in the inventory, simply assign this role to it, and the corresponding IPs will be deduced (either by extracting the primary IPv4 address from its facts or, if the facts are not available, by doing a DNS lookup). However, some options are available to fully control its behaviour, should the need arise; for example, you may wish to explicitly set the IP to use for one of the hosts, or even determine the host's IP by declaring which network interface must be queryed.

The entry for each host in the inventory will be in the format e.g. `192.168.0.1 server.example.com`.
  * The host name will be as it appears in the inventory file, but can be optionally overridden using the option `ih_host_name`.
  * The IP of each host is determined by the following procedure:
    1. If an host is identified by its IP in the inventory itself, it is skipped.
    2. If `ih_host_ip` contains an hash that equals the host name, then its value is used as IP.
    3. If `ih_host_interface` contains an hash that equals the host name, then its valued is used as the network interface to query.
    4. If the host facts have been gathered (either it appears in the playbook, or setup has been called explicitly), then its default IPv4 address is used.
    5. If all else fails, do a DNS query for this host to obtain its IP.

If you wish to revert every change made by this role, the `ih_clear` can be set to `true` to remove every managed line from the hosts. The string signature that marks the managed block can also be controlled by using the `ih_signature` argument, however be aware that if you change this *after* using this role at least once, the previously managed lines will *not* be automatically cleared. Always use `ih_clear` once, before changing `ih_signature`.

Future work:
  - Feature: add new argument to allow setting of host aliases.

Requirements
------------

- Every host in the inventory file must be reachable from the machine executing `ansible-playbook`.
- blockinfile module.
- superuser permissions during role execution, e.g. "become_method: sudo".

Role Variables
--------------
- `ih_signature`: a string that marks the managed block in `/etc/hosts`. Example: `ih_signature: 'Ansible managed block'`
- `ih_host_interface`: a hash map containing, for each host, the name of the interface to use to determine its IP. Example: `ih_host_interface: {'development.myserver.com': 'eth0' }`
- `ih_host_ip`: a hash map contianing the IP to use for each host, overriding any automatically determined value. Example: `ih_host_ip: { 'testing.myserver.com': '192.168.1.15' }`
- `ih_host_name`: a hash map containing an alternative name to use, when including it in `/etc/host`. Example: `ih_host_name: { "test.server.com": "tst.server.com" }`
- `ih_extra_hosts`: a hash map containing additional records to add to hosts file. Example: `ih_extra_hosts: {"anotherhost.server.com": "10.10.40.10"}`
- `ih_clear`: a boolean that, if set to `true`, causes the deletion of the whole managed block from the hosts file. The default value is `false`.

Dependencies
------------

- `dnspython`, but DNS lookups are only carried out if no other way of determining the IP has been found (see the IP determination procedure for details). Depending on your case, you may not need to install it.

Example Playbook
----------------

    - hosts: servers
      roles:
        - mvitale1989.inventory-hosts

    - hosts: other_servers
      roles:
        - role: mvitale1989.inventory-hosts
          ih_signature: 'This block is managed by ansible.'
          ih_host_interface:
            development.server.com: 'eht0'
            testing.server.com: 'ens3'
          ih_host_ip:
            production.server.com: '192.168.3.24'
          ih_host_name:
            testing.server.com: 'tst.server.com'
          ih_extra_hosts:
            another_host.server.com: '10.10.10.50'

License
-------

BSD

Author Information
------------------

https://github.com/mvitale1989
