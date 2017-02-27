# It is intended that this file is copied in to the repository (along with
# the settings.py) file and run.
from django.test.runner import DiscoverRunner

class NucleusRunner(DiscoverRunner):

    def run_suite(self, suite, **kwargs):
        result = super().run_suite(suite, **kwargs)
        return result
