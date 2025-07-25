# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SwiftTail is a Rails 8.0 application using modern Rails conventions with:
- SQLite3 database with Solid Cache, Solid Queue, and Solid Cable
- Propshaft for asset pipeline
- Importmap for JavaScript with Stimulus and Turbo
- Kamal for deployment
- Docker containerization

## Development Commands

### Setup and Installation
```bash
bin/setup                    # Complete setup: install dependencies, prepare DB, start server
bin/setup --skip-server     # Setup without starting server
bundle install              # Install Ruby dependencies
```

### Development Server
```bash
bin/dev                      # Start development server (calls bin/rails server)
bin/rails server            # Start Rails server directly
```

### Database Operations
```bash
bin/rails db:prepare         # Create/setup database
bin/rails db:migrate         # Run migrations
bin/rails db:seed            # Seed database
bin/rails dbconsole          # Database console
```

### Testing
```bash
bin/rails test              # Run all tests
bin/rails test:system       # Run system tests
bin/rails test test/models/specific_test.rb  # Run specific test file
```

### Code Quality
```bash
bin/rubocop                  # Run RuboCop linter
bin/brakeman                 # Run security analysis
```

### Deployment (Kamal)
```bash
bin/kamal deploy             # Deploy application
bin/kamal console            # Remote Rails console
bin/kamal shell              # Remote shell access
bin/kamal logs               # View application logs
```

## Architecture

### Application Structure
- **Module Name**: `SwiftTail` (config/application.rb:9)
- **Rails Version**: 8.0 with modern defaults
- **Database**: SQLite3 with Solid trio (Cache/Queue/Cable)
- **Asset Pipeline**: Propshaft with Importmap
- **Job Processing**: Solid Queue (runs in Puma process via `SOLID_QUEUE_IN_PUMA=true`)

### Key Configuration
- **Autoload**: `config.autoload_lib(ignore: %w[assets tasks])` - lib/ directory auto-loaded except assets/tasks
- **Testing**: Parallel test execution enabled with `parallelize(workers: :number_of_processors)`
- **Deployment**: Configured for single-server deployment with SSL via Let's Encrypt

### Technology Stack
- **Backend**: Rails 8.0, Puma server
- **Frontend**: Turbo + Stimulus (Hotwire), Importmap
- **Database**: SQLite3 with Solid adapters
- **Deployment**: Kamal with Docker
- **Testing**: Minitest with Capybara/Selenium for system tests