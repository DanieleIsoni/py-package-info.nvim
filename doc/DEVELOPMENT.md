# Py Package Info Development

- This doc provides useful information to help with the development of the plugin

## Project Structure

    ├── actions                             # Contains all user runnable plugin actions
    ├── helpers                             # Plugin specific helper functions
    ├── libs                                # External libs like toml parser
    ├── tests                               # Project tests for all the functionality
    ├── ui                                  # User interface components
    ├── utils                               # Generic helper variables and functions
    ├── config.lua                          # Setup of user passed configuration options
    ├── core.lua                            # Responsible loading the plugin in the correct scenarios
    ├── init.lua                            # Exports all the user facing commands
    ├── parser.lua                          # Handles pyproject.toml parsing and installed dependency loading
    ├── state.lua                           # Global plugin state
    └── virtual_text.lua                    # Handles all virtual text related operations
