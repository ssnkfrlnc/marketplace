# Default values
APP ?= marketplace
COMMAND ?= build

# List of available apps
APPS := marketplace app1 app2

# List of available commands for each app
COMMANDS := build dev lint serve-static start test show

# List of affected commands
AFFECTED_COMMANDS := graph test e2e

# List of generation commands
GENERATION_COMMANDS := library component

# List of setup commands
SETUP_COMMANDS := connect other_command

.PHONY: $(COMMANDS) run affected generate setup

# General rule to run commands for the specified app
run:
	@echo "Available apps: $(APPS)"
	@echo "Available commands: $(COMMANDS)"
	@if [ -z "$(APP)" ]; then \
		read -p "Enter app name (default: marketplace): " input_app; \
		APP=$${input_app:-marketplace}; \
	fi
	@if [ -z "$(COMMAND)" ]; then \
		read -p "Enter command (default: build): " input_command; \
		COMMAND=$${input_command:-build}; \
	fi
	@if echo "$(COMMANDS)" | grep -w -q "$(COMMAND)"; then \
		echo "Running $(COMMAND) for $(APP)..."; \
		nx run $(APP):$(COMMAND); \
	else \
		echo "Invalid command: $(COMMAND). Available commands are: $(COMMANDS)"; \
	fi

# Target for affected commands
affected:
	@echo "Available affected commands: $(AFFECTED_COMMANDS)"
	@if [ -z "$(AFFECTED_COMMAND)" ]; then \
		read -p "Enter affected command: " input_affected; \
		AFFECTED_COMMAND=$${input_affected}; \
	fi
	@if [ -n "$(AFFECTED_COMMAND)" ] && echo "$(AFFECTED_COMMANDS)" | grep -w -q "$(AFFECTED_COMMAND)"; then \
		echo "Running nx affected:$(AFFECTED_COMMAND)..."; \
		nx affected:$(AFFECTED_COMMAND); \
	else \
		echo "Invalid affected command: $(AFFECTED_COMMAND). Available commands are: $(AFFECTED_COMMANDS)"; \
	fi

# Target for generation commands
generate:
	@echo "Available generation commands: $(GENERATION_COMMANDS)"
	@if [ -z "$(GENERATION_COMMAND)" ]; then \
		read -p "Enter generation command: " input_generate; \
		GENERATION_COMMAND=$${input_generate}; \
	fi
	@if [ "$(GENERATION_COMMAND)" = "library" ]; then \
		read -p "Enter library name: " lib_name; \
		echo "Generating UI library: $${lib_name}..."; \
		nx g @nx/next:library "$${lib_name}"; \
	elif [ "$(GENERATION_COMMAND)" = "component" ]; then \
		read -p "Enter component name (e.g., ui/src/lib/button): " comp_name; \
		echo "Adding component: $${comp_name}..."; \
		nx g @nx/next:component "$${comp_name}"; \
	elif [ -n "$(GENERATION_COMMAND)" ]; then \
		echo "Invalid generation command: $(GENERATION_COMMAND). Available commands are: $(GENERATION_COMMANDS)"; \
	fi

# Target for setup commands
setup:
	@echo "Available setup commands: $(SETUP_COMMANDS)"
	@if [ -z "$(SETUP_COMMAND)" ]; then \
		read -p "Enter setup command: " input_setup; \
		SETUP_COMMAND=$${input_setup}; \
	fi
	@if [ "$(SETUP_COMMAND)" = "connect" ]; then \
		echo "Activating distributed tasks executions and caching..."; \
		nx connect; \
	elif [ "$(SETUP_COMMAND)" = "other_command" ]; then \
		echo "Running other setup command..."; \
		# Replace this with the actual command for 'other_command'
	elif [ -n "$(SETUP_COMMAND)" ]; then \
		echo "Invalid setup command: $(SETUP_COMMAND). Available commands are: $(SETUP_COMMANDS)";\
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
