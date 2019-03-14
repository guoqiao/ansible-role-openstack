# ansible-role-openstack

## Variables and defaults

refer to `group_vars/all.yml` and `vars`.

## Examples

NOTE: `infra` means everything we need before create servers,
such as network, subnet, router, keypair, security group and rules.

Create infra and 1 server by default:

    - name: create infra and 1 server
      include_role:
        name: openstack

NOTE: this will use `$USER` as default `ENV_NAME`, create infra based on it.
A ubuntu server named `$USER-0` will be created.

Create infra and N servers in parallel:

    - name: create infra and 3 servers
      include_role:
        name: openstack
      vars:
        OS_SERVERS: "{{range(3)|list}}"

NOTE: servers `$USER-[0, 1, 2]` will be created.

Create servers with different attributes:

    - name: create infra and servers
      include_role:
        name: openstack
      vars:
        OS_SERVERS:
          - name: dc0
            flavor: c1.c2r2
            image: ubuntu-16.04-x86_64
            groups:
              - samba-common
              - samba-dc
          - name: tr1
            flavor: c1.c8r16
            image: ubuntu-18.04-x86_64
            groups:
              - samba-common
              - samba-traffic-runner

NOTE: refer to `templates/servers.yml` for available server attributes.

Create infra only:

    - name: create network
      include_role:
        name: openstack
        tasks_from: infra

Create servers only:

    - name: create network
      include_role:
        name: openstack
        tasks_from: servers

Create N Windows instances:

    - name: create N instances
      include_role:
        name: openstack
        vars_from: windows
      vars:
        OS_SERVERS: "{{range(3)|list}}"

Create 1 Ubuntu + 1 Windows instances:

    - name: create Ubuntu
      include_role:
        name: openstack
        vars_from: ubuntu  # default

    - name: create Windows
      include_role:
        name: openstack
        vars_from: windows
