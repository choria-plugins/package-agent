# Choria Package Agent

The package agent that lets you install, uninstall, update, purge and query the status of packages on your system.

The package agent does not do any management of packages itself. Instead it
uses the functionality defined in `MCollective::Util::Package` classes to
perform the actions. By default the Package agent ships with a PuppetPackage
but it's extendable for your own scenarios.

## Installation

This agent is installed by default as part of the [Choria Orchestrator](https://choria.io).

## Configuration

There is one plugin configuration setting for the package agent.

* provider   - The Util class that implements the install, uninstall, purge, update and status behavior. Defaults to 'puppet'

General provider configuration options can then also be set in the config file.

```yaml
mcollective_agent_package::config:
  provider: puppet
  puppet.allowcdrom: true
```

## Authorization

By default the Action Policy system is configured to only allow `status` and `count` and `md5`
actions from all users.  These are read only and does not expose secrets.

Follow the Choria documentation to configure your own policies either site wide or per agent.

If you do configure any Policies specific to this module these defaults will be overriden
when done using Hiera.

An example policy can be seen here:

```yaml
mcollective_agent_package::policies:
  - action: "allow"
    callers: "choria=manager.mcollective"
    actions: "install update uninstall purge"
    facts: "*"
    classes: "*"
```

## Usage
```
% mco rpc package install package=nano

 * [ ============================================================> ] 4 / 4



Summary of Ensure:

   2.0.9-7.el6 = 4


Finished processing 4 / 4 hosts in 18176.83 ms
```

```
% mco package nano uninstall

 * [ ============================================================> ] 4 / 4


Summary of Ensure:

   absent = 4


Finished processing 4 / 4 hosts in 393.68 ms
```
```
% mco rpc package install package=openssl version=0.9.8k-7ubuntu8

 * [ ============================================================> ] 4 / 4



Summary of Ensure:

   0.9.8k-7ubuntu8 = 4


Finished processing 4 / 4 hosts in 18176.83 ms
```

## Data Plugin

The Package agent also supplies a data plugin which uses the Package agent to
check the current status of a package. The data plugin will set installed to
true/false if the package is not installed or not, and will set status to the
currently installed version if it is present and can be used during discovery
or any other place where the MCollective discovery language is used.

```
mco rpc rpcutil ping -S "package('mypackage').installed=false"

mco rpc rpcutil ping -S "package('mypackage').status=3.2-1"
```

## Extending

The default package agent achieves platform portability by using the Puppet
provider system to support package managers on all platforms that Puppet
supports.

If however you are not a Puppet user or simply want to implement some new
method of package management you can do so by providing your own backend
provider for this agent.

The logic for the Puppet version of this agent is implemented in
`Util::Package::PuppetPackage`, you can create a custom package implementation
that overrides `#install`, `#uninstall`, `#update`, `#purge` and `#status`.

This agent defaults to `Util::Package::PuppetPackage` but if you have your own
you can configure it in the config file using:

```yaml
mcollective_agent_package::config:
  provider: puppet
```
