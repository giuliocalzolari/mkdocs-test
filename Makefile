# preview docs
docs-preview: docs-dependencies
	pipenv run mkdocs serve

# publish the versioned docs using mkdocs mike util
docs-publish: docs-dependencies
	pipenv run mike deploy --allow-empty --push --update-aliases v2.7 latest
	pipenv run mike --allow-empty --push set-default latest

# install dependencies needed to preview and publish docs
docs-dependencies:
	pipenv install --dev

docs-test:
	pipenv run mkdocs build --strict

