# Default values
APP ?= marketplace
COMMAND ?= build

# List of available apps
APPS := marketplace

# List of available commands for each app
COMMANDS := build dev lint serve-static start test show

# List of affected commands
AFFECTED_COMMANDS := graph test e2e

# List of generation commands
GENERATION_COMMANDS := library component

# List of setup commands
SETUP_COMMANDS := connect

.PHONY: $(COMMANDS) run affected generate setup

# General rule to run commands for the specified app
run:
	@echo "Available apps: $(APPS)"
	@echo "Available commands: $(COMMANDS)"
	@read -p "Enter app name (default: $(APP)): " input_app; \
	if [ -z "$$input_app" ]; then input_app=$(APP); fi; \
	read -p "Enter command (default: $(COMMAND)): " input_command; \
	if [ -z "$$input_command" ]; then input_command=$(COMMAND); fi; \
	if echo "$(COMMANDS)" | grep -w -q "$$input_command"; then \
		echo "Running $$input_command for $$input_app..."; \
		nx run $$input_app:$$input_command; \
	else \
		echo "Invalid command: $$input_command. Available commands are: $(COMMANDS)"; \
	fi

# New target for affected commands
affected:
	@echo "Available affected commands: $(AFFECTED_COMMANDS)"
	@read -p "Enter affected command: " input_affected; \
	if echo "$(AFFECTED_COMMANDS)" | grep -w -q "$$input_affected"; then \
		echo "Running nx affected:$$input_affected..."; \
		nx affected:$$input_affected; \
	else \
		echo "Invalid affected command: $$input_affected. Available commands are: $(AFFECTED_COMMANDS)"; \
	fi

# New target for generation commands
generate:
	@echo "Available generation commands: $(GENERATION_COMMANDS)"
	@read -p "Enter generation command: " input_generate; \
	if [ "$$input_generate" = "library" ]; then \
		read -p "Enter library name: " lib_name; \
		echo "Generating UI library: $$lib_name..."; \
		nx g @nx/next:library $$lib_name; \
	elif [ "$$input_generate" = "component" ]; then \
		read -p "Enter component name (e.g., ui/src/lib/button): " comp_name; \
		echo "Adding component: $$comp_name..."; \
		nx g @nx/next:component $$comp_name; \
	else \
		echo "Invalid generation command: $$input_generate. Available commands are: $(GENERATION_COMMANDS)"; \
	fi

# New target for setup commands
setup:
	@echo "Available setup commands: $(SETUP_COMMANDS)"
	@read -p "Enter setup command: " input_setup; \
	if [ "$$input_setup" = "connect" ]; then \
		echo "Activating distributed tasks executions and caching..."; \
		nx connect; \
	elif [ "$$input_setup" = "other_command" ]; then \
		# Replace with the actual command you want to run
		echo "Running other setup command..."; \
		# Example: nx some-other-command; \
	else \
		echo "Invalid setup command: $$input_setup. Available commands are: $(SETUP_COMMANDS)"; \
	fi

# Define specific commands for the default app
build:
	nx run $(APP):build

dev:
	nx run $(APP):dev

lint:
	nx run $(APP):lint

serve-static:
	nx run $(APP):serve-static

start:
	nx run $(APP):start

test:
	nx run $(APP):test

show:
	nx show project $(APP) --web
