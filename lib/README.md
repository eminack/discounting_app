# Project Structure

This application follows a structured architecture with the following organization:

## Directory Structure

```
lib/
├── models/         # Data models
│   └── concerns/   # Shared model concerns/modules
├── views/          # View templates and presentation logic
│   └── layouts/    # Layout templates
├── controllers/    # Request handling and flow control
│   └── concerns/   # Shared controller concerns/modules
├── repositories/   # Data access and business logic implementation
├── config/         # Configuration files and initializers
├── services/       # Service objects for complex operations
└── helpers/        # View helpers and utility modules
```

## Directory Purposes

### Models (`lib/models/`)
- Contains data models
- Defines attributes and validations
- Example: `lib/models/discount.rb`, `lib/models/user.rb`

### Views (`lib/views/`)
- Contains templates for rendering output
- Handles presentation logic
- Example: `lib/views/discounts/index.rb`

### Controllers (`lib/controllers/`)
- Handles request processing
- Manages application flow
- Example: `lib/controllers/discounts_controller.rb`

### Repositories (`lib/repositories/`)
- Implements data access logic
- Contains business logic
- Handles database operations
- Example: `lib/repositories/discounts.rb`

### Config (`lib/config/`)
- Contains configuration files
- Manages environment settings
- Example: `lib/config/database.rb`

### Services (`lib/services/`)
- Contains service objects
- Handles complex operations
- Example: `lib/services/discount_calculator.rb`

### Helpers (`lib/helpers/`)
- Contains view helpers
- Provides utility methods
- Example: `lib/helpers/formatting_helper.rb`

## Best Practices

1. Keep models focused on attributes and validations
2. Implement business logic in repositories
3. Use services for complex operations
4. Keep views simple and presentation-focused
5. Use helpers for view-specific formatting 