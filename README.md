# ansible-role-openstack

Create infrastructure and servers in openstack cloud.

## Prerequisites
Install python packages:

    pip3 install -r requirements.txt

Source your openstack rc file, to check:

    env | grep OS_
    openstack server list

## Installation

Add to `requirements.yml`:

    - src: git+https://github.com/catalyst-samba/ansible-role-openstack.git
      name: openstack

Install:

    ansible-galaxy install -f -r requirements.yml

This will install role into `~/.ansible/roles`.

You can also link the repo to there to use source code:

    cd ~/.ansible/roles
    ln -s ~/git/ansible-role-openstack openstack

## Examples

NOTE: `infra` means everything we need before create servers,
such as network, subnet, router, keypair, security group and rules.

A play to create infra and 1 server by default:

    - name: run role
      hosts: localhost
      tasks:
        - name: create infra and 1 server
          include_role:
            name: openstack


This role should run on localhost, to call openstack API, openstack rc file must be sourced first.
Following examples will only show the task.
Be default, it will use `$USER` as default `ENV_NAME`, create infra based on it.
1 ubuntu server will be created.

Task to create infra and N servers in parallel:

    - name: create infra and 3 servers
      include_role:
        name: openstack
      vars:
        OS_SERVERS: "{{range(3)|list}}"


NOTE: servers `$USER-[0, 1, 2]` will be created.

Task to create servers with different attributes:

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

Create 1 Ubuntu + 1 Windows instance:

    - name: create Ubuntu
      include_role:
        name: openstack
        vars_from: ubuntu  # default

    - name: create Windows
      include_role:
        name: openstack
        vars_from: windows

## Variables and defaults

refer to [defaults/all.yml](defaults/all.yml) and [vars](vars).

