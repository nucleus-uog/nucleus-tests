# Clone the repo from the environment variable.
git clone $TESTS_REPO_URL /nucleus/repo

# Copy our tests in.
mv /nucleus/tests/*.py /nucleus/repo/application/tests/

# Install python requirements.
pip install -r /nucleus/repo/requirements.txt
