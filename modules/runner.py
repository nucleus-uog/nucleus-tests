# It is intended that this file is copied in to the repository (along with
# the settings.py) file and run.
import os
import json
from os.path import join, exists, isfile
from copy import deepcopy
from django.test.runner import DiscoverRunner

STUDENT_EMAIL = os.environ['STUDENT_EMAIL']

class NucleusRunner(DiscoverRunner):

    def run_suite(self, suite, **kwargs):
        # We need to save the suite as it is now as the
        # test cases in the suite get set to None once
        # they are run.
        self.original_suite = deepcopy(suite)

        result = super().run_suite(suite, **kwargs)
        self.output_results(result)
        return result

    def output_results(self, test_results):
        base_output_directory = join(os.getcwd(), 'results')
        student_output_directory = join(base_output_directory,
                                        STUDENT_EMAIL)

        self.mkdir_if_not_exists(base_output_directory)
        self.mkdir_if_not_exists(student_output_directory)

        output_file = join(student_output_directory, 'results.json')
        output = {
            'student': STUDENT_EMAIL,
            'tests': []
        }
        results = {}

        if exists(output_file) and isfile(output_file):
            output = self.load_existing(output_file)

            for test in output['tests']:
                results['{} ({})'.format(test['test'], test['case'])] = test

        for test in self.original_suite:
            results[str(test)] = {
                'case': self.strclass(test.__class__),
                'test': test._testMethodName,
                'passed': True
            }

        def set_errors(results, errors):
            for test, log in errors:
                error_filename = '{}-{}-error.txt'.format(self.strclass(test.__class__),
                                                          test._testMethodName)
                error_filepath = join(student_output_directory, error_filename)

                with open(error_filepath, 'w+') as f:
                    f.write(log)
                
                results[str(test)].update({
                    'passed': False,
                    'error': './' + error_filename
                })
            return results

        results = set_errors(results, test_results.errors)
        results = set_errors(results, test_results.failures)

        output['tests'] = list(results.values())
        with open(output_file, 'w+') as f:
            f.write(json.dumps(output, sort_keys=True, indent=4))

    def load_existing(self, path):
        with open(path, 'r') as f:
            data = json.loads(f.read())
        return data

    def mkdir_if_not_exists(self, path):
        if not exists(path):
            os.mkdir(path)

    def strclass(self, cls):
        return '{}.{}'.format(cls.__module__, cls.__qualname__)
