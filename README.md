mvitale1989.inventory-hosts
=========

Ansible role to automatically add every inventory host to each host's /etc/hosts. It uses the hostname as it appears in the inventory file, and allow co-existence with any additional manual configuration on each hosts' /etc/hosts, by using a signature to distinguish the lines it has jurisdiction over.

You can control the way it deduces each of the hosts' IP (by explicit definition, by interface or by letting ansible figure the default IP) and the signature used to mark managed /etc/hosts lines.

Requirements
------------

- On the host you call "ansible-playbook" from, the /etc/hosts file must alreadymust be configured manually to contain the controlled hosts
- lineinfile module
- superuser permissions during role execution, e.g. "become_method: sudo"

Role Variables
--------------

- ih_signature: the string that marks managed lines in /etc/hosts. Example: "ih_signature: 'this_marks_a_line_managed_by_ansible'"
- ih_host_interface: a hash map containing, for each host, the name of the interface to use to determine its IP. Example: "ih_host_interface: {'development.myserver.com': 'eth0' }"
- ih_host_ip: a hash map contianing the explicit IP to use for each host. Example: "ih_host_ip: { 'testing.myserver.com': '192.168.1.15' }"

Dependencies
------------

This module has no dependencies

Example Playbook
----------------

    - hosts: servers
      roles:
        - mvitale1989.inventory-hosts

    - hosts: other_servers
      roles:
        - role: mvitale1989.inventory-hosts
          ih_signature: 'this_line_is_managed_by_ansible'
          ih_host_interface:
            development.server.com: 'eht0'
            testing.server.com: 'ens3'
          ih_host_ip:
            production.server.com: '192.168.3.24'

License
-------

BSD

Author Information
------------------

https://github.com/mvitale1989
