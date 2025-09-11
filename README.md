# Semaphore agent AWS stack

This project is a CDK application used to deploy a fleet of Semaphore agents in your AWS account.

## Features

- Run self-hosted agents in Linux and Windows machines
- Dynamically increase and decrease the number of agents available based on your job demand
- Deploy multiple stacks of agents, one for each self-hosted agent type
- Access the agent EC2 instances through SSH or using AWS Systems Manager Session Manager
- Use an S3 bucket to cache the dependencies needed for your jobs
- Control the size of your agent instances and of your agent pool

Check out the [docs](https://docs.semaphoreci.com/ci-cd-environment/aws-support).

# Semaphore agent AWS stack

This project is a CDK application used to deploy a fleet of Semaphore agents in your AWS account.

## Features

- Run self-hosted agents in Linux and Windows machines
- Dynamically increase and decrease the number of agents available based on your job demand
- Deploy multiple stacks of agents, one for each self-hosted agent type
- Access the agent EC2 instances through SSH or using AWS Systems Manager Session Manager
- Use an S3 bucket to cache the dependencies needed for your jobs
- Control the size of your agent instances and of your agent pool

Check out the [docs](https://docs.semaphoreci.com/ci-cd-environment/aws-support).

## Extending the Linux AMI with additional tools (Ruby via rbenv, PostGIS, Redis, Node.js)

The Linux AMI build can optionally install the following developer tools. Use Makefile flags to enable them when validating/building with Packer:

- INSTALL_RUBY=true to install rbenv system-wide and Ruby 3.3.7 (set as global), plus Bundler. Ruby is installed via rbenv for flexible version management.
- INSTALL_POSTGIS=true to install PostgreSQL with PostGIS extension. This installs PostgreSQL (default version 16) with PostGIS 3 extension via the PostgreSQL PGDG repository.
- INSTALL_REDIS=true to install Redis server (version 7 from RedisLabs PPA) and enable the service.
- INSTALL_NODE=true to install Node.js (default major 20) from NodeSource and enable Corepack (yarn/pnpm shims).

Defaults and version overrides:

- Ruby: default version 3.3.7 via rbenv and set as system-wide global. Override with RUBY_VERSION (e.g., 3.2.4). rbenv is added to PATH for all users via /etc/profile.d/rbenv.sh and to the container user's .bashrc.
- PostgreSQL with PostGIS: default major version 16 with PostGIS 3. Override with POSTGRES_VERSION (e.g., 14) and POSTGIS_VERSION (e.g., 3).
- Redis: installs Redis server from the RedisLabs PPA when enabled.
- Node.js: default major version 20. Override with NODE_VERSION (e.g., 22). Corepack is enabled; yarn and pnpm will be available via shims.

Examples:

- Validate with Ruby and Node.js:
  make packer.validate PACKER_OS=linux INSTALL_RUBY=true INSTALL_NODE=true

- Validate with PostGIS and Redis:
  make packer.validate PACKER_OS=linux INSTALL_POSTGIS=true INSTALL_REDIS=true

- Validate with custom versions:
  make packer.validate PACKER_OS=linux INSTALL_RUBY=true RUBY_VERSION=3.2.4 INSTALL_POSTGIS=true POSTGRES_VERSION=14

- Build with all components:
  make packer.build PACKER_OS=linux INSTALL_RUBY=true INSTALL_POSTGIS=true INSTALL_REDIS=true INSTALL_NODE=true

You can also pass these directly to Packer if not using the Makefile: install_ruby, install_postgis, install_redis, install_node, ruby_version, postgres_major_version, postgis_major_version, node_major_version.
