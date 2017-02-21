# Check if repo url exists.
: "${TESTS_REPO_URL:?Repository URL was not provided. Exiting...}"

# Clone the repo from the environment variable.
printf ":: Cloning $TESTS_REPO_URL to ./repo\n"
git clone $TESTS_REPO_URL ./repo

# Check if repository was cloned.
ROOT=./repo/
if [ ! -d $ROOT ]; then
	printf "\n:: Unable to clone repository. Please see error above. Exiting...\n"
	exit 1
fi

# Determine whether application is at root of repo or
# in tango_with_django_project subfolder.
if [ ! -f $ROOT/manage.py ]; then
	ROOT="$ROOT/tango_with_django_project/"
fi
printf "\n:: Application root found in $ROOT\n"

# Copy our tests in.
printf "\n:: Copying tests into $root/rango/tests/\n"
mkdir $ROOT/rango/tests
mv ./tests/*.py $ROOT/rango/tests/

# Install python requirements.
if [ ! -f ./repo/requirements.txt ]; then
	printf "\n:: Using default requirements, none supplied by project.\n"
	pip install -r default-requirements.txt
else
	printf "\n:: Installing project requirements from requirements.txt\n"
	pip install -r ./repo/requirements.txt
fi

# Run testing script.
printf "\n:: Running test runner\n"
python ./test.py
