# This script is intended to be run from the run.sh script.
import os
from subprocess import Popen
from os import listdir
from os.path import isfile, join

REPO_PATH = os.environ['REPO_ROOT']
TESTS_PATH = os.environ['TESTS_DIR']
STUDENT_EMAIL = os.environ['STUDENT_EMAIL']
MANAGE_PATH = REPO_PATH + '/manage.py'

def run():
    # Find the tests.
    tests = find_tests()

    env = os.environ.copy()
    env['DJANGO_SETTINGS_MODULE'] = 'tango_with_django_project.test_settings'
    env['STUDENT_EMAIL'] = STUDENT_EMAIL
    # Run the tests.
    for test in tests:
        print(':: Running tests from ' + test['file_name'])

        process = Popen(['python', MANAGE_PATH, 'test', test['module']],
                        env=env)
        process.communicate()
        
        print(':: Finished running tests from ' + test['file_name'] + '\n') 

def find_tests():
    contents_of_folder = [f for f in listdir(TESTS_PATH)]
    files = [f for f in contents_of_folder if isfile(join(TESTS_PATH,f))]
    test_files = [f[:len(f) -3] for f in files if f.startswith('tests_')]

    module_prefix = 'rango.tests.'
    
    # Return a dictionary with the filenames and the
    # module that would be required to run the tests.
    return [{
        'file_name': file_name,
        'module': module_prefix + file_name
    } for file_name in test_files]

if __name__ == '__main__':
    run()
