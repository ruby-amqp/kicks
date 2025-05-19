# Change Log

## Changes Between 3.2.0 and 3.3.0 (in development)

### Improved Bunny Exception Handling for Consumers

Contributed by @shashankmehra.

GitHub issue: [#35](https://github.com/ruby-amqp/kicks/pull/35)

### Improved Logger Configuration

Contributed by @cdhagmann.

GitHub issue: [#34](https://github.com/ruby-amqp/kicks/pull/34)

### Bunny Version Bump

Kicks now requires the latest (at the time of writing) Bunny `2.24.x`.

### Support Rails 7.2

Contributed by @sekrett.

GitHub issue: [#32](https://github.com/ruby-amqp/kicks/pull/32)


## Changes Between 3.1.0 and 3.2.0 (Jan 26, 2025)

### Improved Support for Bring-Your-Own-Connection (BYOC)

Kicks now supports passing in a callable (e.g. a proc) instead of an externally-initialized
and managed Bunny connection. 

In this case, it is entirely up to the caller
to configure the connection and call `Bunny::Session#start` on it
at the right moment.

Contributed by @tie.

GitHub issue: [#29](https://github.com/ruby-amqp/kicks/pull/29)


### ActiveJob Adapter Compatibility with Ruby on Rails Older Than 7.2

Contributed by @dixpac.

GitHub issues: [#19](https://github.com/ruby-amqp/kicks/pull/19), [#28](https://github.com/ruby-amqp/kicks/pull/28)


## Changes Between 3.0.0 and 3.1.0 (Oct 20, 2024)

### ActiveJob Adapter

Kicks now ships with an ActiveJob adapter for Ruby on Rails.

Contributed by dixpac.

GitHub issue: [#12](https://github.com/ruby-amqp/kicks/pull/12)

### Make Queue Binding Optional

It is now possible to opt out of binding of the Kicks-declared exchange and queue.

Contributed by @texpert.

GitHub issue: [#13](https://github.com/ruby-amqp/kicks/pull/13)


## Changes Between 2.12.0 and 3.0.0 (Oct 19, 2024)

### New Project Name and Major Version

Kicks was originally developed by @jondot under the [name of Sneakers](https://github.com/jondot/sneakers).

After a group of users and a RabbitMQ core team member have taken over maintenance, it was renamed
to Kicks and the version was bumped to 3.0 to clearly indicate the split.

### Minimum Required Ruby Version

Kicks now requires Ruby 2.5 or later.

### Content Encoding Support

Similar to already supported content type.

Contributed by @ansoncat.

GitHub issue: [#449](https://github.com/jondot/sneakers/pull/449)


## Changes Between 2.10.0 and 2.11.0

This releases includes bug fixes, support for more queue-binding options, better
management of the Bunny dependency, and improved documentation. Following is a
list of the notable changes:

### Rescue from ScriptError

Fixes a bug that would cause Sneakers workers to freeze if an exception
descending from `ScriptError`, such as `NotImplementedError`, is raised

Contributed by @sharshenov

GitHub Pull Request: [373](https://github.com/jondot/sneakers/pull/373)

### Loosen Bunny dependency to minor version

The dependency on Bunny is now pinned to the minor version instead of patch,
allowing users to benefit from non-breaking updates to Bunny without having to
wait for a Sneakers release.

Contributed by @olivierlacan

GitHub Pull Request: [#372](https://github.com/jondot/sneakers/pull/372)

### Support `:bind_arguments` on bind

It is now possible to set arguments on a queue when connecting to a headers
exchange

Contributed by @nerikj

GitHub Pull Request: [#358](https://github.com/jondot/sneakers/pull/358)

### Other contributions

This release also contains contributions from @ivan-kolmychek (bumping up Bunny
dependency), @michaelklishin (improving code style), and @darren987469 (adding
examples to the README)

## Changes Between 2.8.0 and 2.10.0

This release contains **minor breaking API changes**.

### Worker Timeouts are No Longer Enforced

This is a **breaking change** for `Sneakers::Worker` implementations.

Timeouts can be disruptive and dangerous depending on what the workers do but not having them can also
lead to operational headaches.

The outcome of [a lengthy discussion](https://github.com/jondot/sneakers/issues/343) on possible
alternatives to the timeout mechanisms is that only applications
can know where it is safe to enforce a timeout (and how).

`Sneakers::Worker` implementations are now expected to enforce timeouts
in a way that makes sense (and is safe) to them.

GitHub issues: [#343](https://github.com/jondot/sneakers/issues/343).


## Changes Between 2.6.0 and 2.7.0

This release requires Ruby 2.2 and has **breaking API changes**
around custom error handlers.

### Use Provided Connections in WorkerGroup

It is now possible to use a custom connection instance in worker groups.

Contributed by @pomnikita.

GitHub issue: [#322](https://github.com/jondot/sneakers/pull/322)


### Worker Context Available to Worker Instances

Contributed by Jason Lombardozzi.

GitHub issue: [#307](https://github.com/jondot/sneakers/pull/307)


### Ruby 2.2 Requirement

Sneakers now [requires Ruby 2.2](https://github.com/jondot/sneakers/commit/f33246a1bd3b5fe53ee662253dc5bac7864eec97).


### Bunny 2.9.x

Bunny was [upgraded](https://github.com/jondot/sneakers/commit/c7fb0bd23280082e43065d7199668486db005c13) to 2.9.x.



### Server Engine 2.0.5

Server Engine dependency was [upgraded to 2.0.5](https://github.com/jondot/sneakers/commit/3f60fd5e88822169fb04088f0ce5d2f94f803339).


### Refactored Publisher Connection

Contributed by Christoph Wagner.

GitHub issue: [#325](https://github.com/jondot/sneakers/pull/325)


### New Relic Reporter Migrated to the Modern API

Contributed by @adamors.

GitHub issue: [#324](https://github.com/jondot/sneakers/pull/324)


### Configuration Logged at Debug Level

To avoid potentially leaking credentials in the log.

Contributed by Kimmo Lehto.

GitHub issue: [#301](https://github.com/jondot/sneakers/pull/301).


### Comment Corrections

Contributed by Andrew Babichev

GitHub issue: [#346](https://github.com/jondot/sneakers/pull/346)
