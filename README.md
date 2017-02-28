# Nucleus Tests
[![build status](https://gitlab.com/devine-industries/nucleus-tests/badges/master/build.svg)](https://gitlab.com/devine-industries/nucleus-tests/commits/master)
[![coverage report](https://gitlab.com/devine-industries/nucleus-tests/badges/master/coverage.svg)](https://gitlab.com/devine-industries/nucleus-tests/commits/master)

This project contains the tests used within the primary Nucleus application. It is intended to be distributed as a docker container and run in a job queue for students.

## Status
The status of this project can be checked in the task list below.
- [x] Docker Container
- [x] Results Output
- [ ] Finalized Tests
- [ ] Integrate `test.py` into `run.sh`

## How to use
### Docker (reccomended)
You can run the testing application using Docker by running the following command:
```sh
$ docker run \
   --name nucleus-tests \
   -e TESTS_REPO_URL=<REPO_URL> \
   -e TESTS_STUDENT=<STUDENT_EMAIL> \
   -v </path/to/results>:/nucleus/results \
   registry.gitlab.com/devine-industries/nucleus-tests:latest
```
You should replace `TESTS_REPO_URL` with the clone url that should be supplied to `git clone` and `TESTS_STUDENT` with the email address of the student that is being tested.

The container will output the results to a `results.json` file in the `/path/to/results` directory supplied. When running, you should replace `/path/to/results/` with the path you would like the output to be in - for Windows machines, this will be in the format `//c/Users/David/Projects/wad2/results` or similar.

To install Docker to your system, follow the guides on the [Docker website](https://www.docker.com/products/overview). Windows users without Hyper-V will need to run the unsupported Docker Toolbox rather than the new Docker for Windows - the tests should still work.
### Manual
If you opt to run the tests manually, you can clone this repository and run the following commands:
```sh
$ python -V
Python 3.x.x
$ python -m venv venv
$ source venv/bin/activate
$ TESTS_REPO_URL=<REPO_URL> TESTS_STUDENT=<STUDENT_EMAIL> ./run.sh
```
This will output the results in the `./results` folder inside the cloned repository.

## How it works
The application is provided with two environment variables - `TESTS_REPO_URL` and `TESTS_STUDENT` - these variables are the only input provided. If the test are built as a docker container, it will ship with Python 3 installed and will then launch the `run.sh` script. If the tests are run manually, then the user will set up the virtual environment and run `run.sh`.

`run.sh` is the entrypoint to the tests - it validates that the environment variables and provided and then proceeds to clone the repository specified by `TESTS_REPO_URL`. Once cloned, the script determines where the root of the Django application is within the cloned repository. We then install the Python dependencies using pip from the `requirements.txt` file specified by the cloned repository, or using our own `default_requirements.txt` file. All of the tests and code required are then copied into the repository before the `test.py` script is run to continue the process.

`test.py` then finds all of the tests (files that start with `test_` in the `tests` directory) and runs `python $APP_ROOT/manage.py test $MODULE` for each - replacing `$APP_ROOT` with the previously calculated root of the Django application and replacing `$MODULE` with the name of the test file prefixed by the location of the copied tests within the cloned repository.

When running the tests, we replace the `DJANGO_SETTINGS_MODULE` environment variable to load our own custom settings (`modules/settings.py`) that are copied in - these settings inherit all the settings from the cloned repository, but replace the `TEST_RUNNER` setting so that a custom test runner is used. Our runner (`modules/runner.py`) is a subclass of the default `DiscoverRunner` provided by Django - it overrides the `run_suite()` function to log the results of the testing to the output directory before returning them as usual.
