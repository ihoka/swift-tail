# SwiftTail

A modern Rails 8.0 application using Hotwire and SQLite.

## Prerequisites

- Ruby 3.3+
- [mise](https://mise.jdx.dev/) (recommended) or bundler

## Setup

### With mise (recommended)
```bash
mise install          # Install Ruby and other tools
bin/setup              # Setup database and dependencies
```

### Without mise
```bash
bundle install         # Install dependencies
bin/rails db:prepare   # Setup database
```

## Development

### Running the application
```bash
bin/dev                # Start development server
# or
mise run rails:dev     # Alternative with mise
```

### Code quality
```bash
bin/rubocop            # Run linter
bin/brakeman           # Security analysis
mise run rubocop:fix   # Auto-fix RuboCop issues
```

### Testing
```bash
bin/rails test         # Run all tests
bin/rails test:system  # System tests only
```

## Technology Stack

- **Framework**: Rails 8.0 with modern defaults
- **Database**: SQLite3 with Solid Cache, Queue, and Cable
- **Frontend**: Turbo + Stimulus (Hotwire), Importmap
- **Assets**: Propshaft pipeline
- **Deployment**: Fly.io via GitHub Actions

## Deployment

Deployment is automated via GitHub Actions when pushing to the main branch.
