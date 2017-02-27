# Check if repo url exists.
: "${TESTS_REPO_URL:?Repository URL was not provided. Exiting...}"
: "${TESTS_STUDENT:?Student email was not provided. Exiting...}"

# Define helpful variables
ROOT=./repo
TESTS_DIR=./tests

# Removing the repo directory if it already exists.
rm -rf $ROOT
printf ":: Removing the $ROOT directory if it exists\n"

# Clone the repo from the environment variable.
printf ":: Cloning $TESTS_REPO_URL to $ROOT\n"
git clone $TESTS_REPO_URL $ROOT

# Check if repository was cloned.
if [ ! -d $ROOT ]; then
	printf "\n:: Unable to clone repository. Please see error above. Exiting...\n"
	exit 1
fi

# Determine whether application is at root of repo or
# in tango_with_django_project subfolder.
if [ ! -f $ROOT/manage.py ]; then
	ROOT="$ROOT/tango_with_django_project"
fi
if [ ! -f $ROOT/manage.py ]; then
	printf "\n:: Unable to determine root of project. Exiting...\n"
	exit 1
fi
printf "\n:: Application root found in $ROOT\n"

# Copy our tests in.
printf "\n:: Copying tests into $ROOT/rango/tests/\n"
mkdir $ROOT/rango/tests
cp $TESTS_DIR/*.py $ROOT/rango/tests/

# Copy our test runner in.
printf "\n:: Copying custom test runner into $ROOT\n"
cp ./modules/settings.py $ROOT/tango_with_django_project/test_settings.py
cp ./modules/runner.py $ROOT/tango_with_django_project/runner.py

# Install python requirements.
if [ ! -f ./repo/requirements.txt ]; then
	printf "\n:: Using default requirements, none supplied by project.\n"
	pip install -r default-requirements.txt
else
	printf "\n:: Installing project requirements from requirements.txt\n"
	pip install -r ./repo/requirements.txt
fi

# Run testing script.
printf "\n"
REPO_ROOT=$ROOT PROJECT_ROOT=$PROJECT TESTS_DIR=$TESTS_DIR STUDENT_EMAIL=$TESTS_STUDENT python ./test.py
