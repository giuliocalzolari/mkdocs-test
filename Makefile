# Variables
VENV_DIR = venv
PYTHON = python3
ACTIVATE = $(VENV_DIR)/bin/activate


# Create virtual environment
venv:
	$(PYTHON) -m venv $(VENV_DIR)

# Install dependencies
install:
	pip install -r requirements.txt

# Activate virtual environment
activate: install
	. $(ACTIVATE)

# Clean up virtual environment
clean:
	rm -rf $(VENV_DIR)

# preview docs
docs-preview:
	mkdocs serve

# publish the versioned docs using mkdocs mike util
docs-publish:
	mike deploy --allow-empty --push --update-aliases $(TARGET)

docs-test:
	mkdocs build --strict

