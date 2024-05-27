# preview docs
docs-preview: docs-dependencies
	pipenv run mkdocs serve

# publish the versioned docs using mkdocs mike util
docs-publish: docs-dependencies
	pipenv run mike deploy v2.7 latest -p --update-aliases

# install dependencies needed to preview and publish docs
docs-dependencies:
	pipenv install --dev

lint:
	echo "TODO"

