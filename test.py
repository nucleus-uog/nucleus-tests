import subprocess 
import os
from os import listdir
from os.path import isfile, join

REPO_PATH = os.environ['REPO_ROOT']
TESTS_PATH = os.environ['TESTS_DIR']
MODULE = 'rango.tests.'

def run():
    tests = find_tests()

    for test in tests:
        print(':: Running tests from ' + test['file_name'])
        process = subprocess.run(['python', REPO_PATH + '/manage.py', 'test', test['module']],
                                 stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        test['log'] = process.stdout
        print(':: Finished running tests from ' + test['file_name'] + '\n') 

def find_tests():
    contents_of_folder = [f for f in listdir(TESTS_PATH)]
    files = [f for f in contents_of_folder if isfile(join(TESTS_PATH,f))]
    tests = [f for f in files if f.startswith('tests_')]

    # Return a dictionary with the filenames and the
    # module that would be required to run the tests.
    return [{
          'file_name': f,
          'module': MODULE + f[:len(f) - 3] # Remove ".py"
        } for f in tests]

if __name__ == '__main__':
    run()
