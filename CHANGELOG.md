# Changelog

Change history for `choria/mcollective_agent_package`

## 5.5.1

Released 2024-08-26

 * Support latest ruby and use new module layout

## 5.4.1

Release 2024-02-04

 * Ruby 3.2 support

## 5.4.0

Released 2021-11-07

 * Run the purge action for uninstalled packages (#25)

## 5.3.0

Release 2020-07-07

 * Improve handling of operating systems that does not report architecture in packages
 * Improve handling absent and purged packages
 * Add a refresh action to update available package list (#23)
 * Add FreeBSD pkg support (#21)

## 5.2.0

Release 2019-11-26

 * Fix return value for apt_update (#11)
 * Add the ability to search for available packages (#15)

## 5.1.0

Release 2018-12-01

 * Add support for checking updates via the `mco package` cli tool (#22)

## 5.0.1

Released 2018-04-20

 * Include JSON DDL files
 * Add Licencing files and contribution guidelines

## 5.0.0

Released 2018-02-27

* Add default action policies (1)
* Fork from Puppet Inc

## 4.7.0

* Fix the package data provider when checking for installed packages (MCOP-609)
* Allow additional yum and apt operations via the client, as noted in `mco package --help` (MCOP-607)

## 4.6.0

* Add count and md5 methods (MCOP-593)

## 4.5.0

* Fix a bug when no version is passed to the agent (PR#23)
* Add a data plugin for package status (PR#25)

## 4.4.0

* Add zypper provider for SLES (MCOP-224)
* Add a version option to the install action (PR#1, PR#14)
* Add a yum provider for RedHat variants (PR#3, PR#15)

## 4.3.1

Released 2014-06-18

* Test more carefully for the windows provider to avoid breaking
  chocolatey (MCOP-18)
* Updated packaging metadata to build for RHEL7 and Ubuntu Trusty (MCOP-69)
* Handle empty response sets more gracefully (MCOP-55)


## 4.3.0

Released 2014-03-10

* Fix uninstall action on Windows systems (MCOP-14)


## 4.2.2

Released 2014-01-28

* Allow uninstall action to work with Puppet 3.4 and newer (MCOP-2)


## 4.2.1

Released 2014-01-02

* Allow agent to work with Puppet 3.4 (MCO-144)



## 4.2.0

Released 2013-03-04

* Remove Package agent data plugin (19563)


## 4.1.0

Released 2013-02-21

* Allow application parameters to be passed as either `action package` or `package action` (19371)


## 4.0.0

Released 2013-02-14

* Rewrite and publish package agent (18772)
