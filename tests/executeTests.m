import matlab.unittest.TestRunner;
import matlab.unittest.constraints.StartsWithSubstring;
import matlab.unittest.selectors.HasBaseFolder;
import matlab.unittest.selectors.HasTag;

% suite = testsuite(fullfile(pwd, 'tests'), 'IncludeSubfolders', true);
% suite = suite.selectIf(HasBaseFolder(StartsWithSubstring(fullfile(pwd, 'tests'))));
% suite = suite.selectIf(HasTag('LegacyTests'));
% suite = testsuite(pwd, 'IncludeSubfolders', false);
% runner = TestRunner.withTextOutput();
% results = runner.run(suite);
% disp("I GOT HERE");
% display(results);
% assertSuccess(results);