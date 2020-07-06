# Simpler

**Simpler** is a little web framework written in [Ruby](https://www.ruby-lang.org) language. It's compatible with [Rack](https://rack.github.io) interface and intended to **learn** how web frameworks works in general.

## The application overview

Simpler application is a singleton instance of the `Simpler::Application` class. For convenience it can be obtained by calling `Simpler.application` method. This instance holds all the routes and responds to `call` method which is required by the Rack interface.
