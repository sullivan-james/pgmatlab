The legacy tests compare the outputs of up-to-date pgmatlab code with
the stable outputs from v1 (as at 25/08/2025). It is limited to testing
only modules that were available in v1. To test new modules that are
created at a later date, please write new unit tests.

Run the code by executing the following MATLAB command from the `root`
directory of the repository.

```matlab
addpath(tests)
run(LegacyTests)
```

Check out the main README file for more information about pgmatlab.