# Nucleus Tests
This repository contains the code required to build the nucleus-tests docker container used within the primary Nucleus application.

## Status
This part of the Nucleus application is still in development.

## How to use
There are two ways to run the tests: you can run the docker container, passing the repository url to be cloned as `TESTS_REPO_URL`. Or you can clone the repository and run the following:

```sh
$ TESTS_REPO_URL=https://github.com/rango/app.git ./run.sh
```

## How it works
When the docker container is run, it is passed a environment variable, `$TESTS_REPO_URL` that contains the URL to be cloned by git for testing.

The container is built with all of the system requirements pre-installed. Once the git repository is cloned, the `run.sh` script finds the root of the project (ie. the folder which contain's Django's `manage.py` file). The tests are then copied into the project's folder.

We then install the requirements for the project, as specified in the project's requirements.txt file, or if not specified by the project, we use a default set of requirements from the `default-requirements.txt` file.

We then hand-off to a Python script which runs the tests, extracts the errors, and returns them in a format that the Nucleus application understands and can add to the database.
