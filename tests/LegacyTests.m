% test the outputs of pgmatlab code with legacy code to ensure
% consistent interface and data.

classdef LegacyTests < matlab.unittest.TestCase
    properties
        currentLibName = 'pgmatlab';
        oldLibName = 'tests/legacy';
        dataRootDir = './tests/data/';
    end
    properties (TestParameter)
        filePath = {
            'processing/ais/ais_v1_test1.pgdf', 'classifiers/deeplearningclassifier/deeplearningclassifier_v2_test1_detections.pgdf', 'classifiers/deeplearningclassifier/deeplearningclassifier_v2_test1_models.pgdf', 'detectors/click/click_v4_test1.pgdf', 'detectors/click/click_v4_test2.pgdf', 'detectors/click/click_v4_test3.pgdf', 'detectors/clicktriggerbackground/clicktriggerbackground_v0_test1.pgdf', 'detectors/gpl/gpl_v2_test1.pgdf', 'detectors/gpl/gpl_v2_test2.pgdf', 'detectors/rwedge/RW_Edge_Detector_Right_Whale_Edge_Detector_Edges_20090328_230139.pgdf', 'detectors/whistleandmoan/whistleandmoan_v2_test1.pgdf', 'plugins/geminithreshold/geminithreshold_test1.pgdf', 'plugins/spermwhaleipi/spermwhaleipi_v1_test1.pgdf', 'processing/clipgenerator/clipgenerator_v3_test1.pgdf', 'processing/clipgenerator/clipgenerator_v3_test2.pgdf', 'processing/dbht/dbht_v2_test1.pgdf', 'processing/difar/difar_v2_test1.pgdf', 'processing/difar/difar_v2_test2.pgdf', 'processing/difar/difar_v2_test3.pgdf', 'processing/ishmael/ishmaeldetections_energysum_v2_test1.pgdf', 'processing/ishmael/ishmaeldetections_energysum_v2_test2.pgdf', 'processing/ishmael/ishmaeldetections_energysum_v2_test3.pgdf', 'processing/ishmael/ishmaeldetections_matchedfilter_v2_test1.pgdf', 'processing/ishmael/ishmaeldetections_matchedfilter_v2_test2.pgdf', 'processing/ishmael/ishmaeldetections_spectrogramcorrelation_v2_test1.pgdf', 'processing/ishmael/ishmaeldetections_spectrogramcorrelation_v2_test2.pgdf', 'processing/longtermspectralaverage/longtermspectralaverage_v2_test1.pgdf', 'processing/noiseband/noiseband_v3_test1.pgdf', 'processing/noiseband/noisebandnoise_v3_test1.pgdf', 'processing/noiseband/noisebandpulses_v3_test1.pgdf', 'processing/noisemonitor/noisemonitor_v2_test1.pgdf', ...
            'processing/ais/ais_v1_test1.pgdx', 'classifiers/deeplearningclassifier/deeplearningclassifier_v2_test1_detections.pgdx', 'classifiers/deeplearningclassifier/deeplearningclassifier_v2_test1_models.pgdx', 'detectors/click/click_v4_test1.pgdx', 'detectors/click/click_v4_test2.pgdx', 'detectors/click/click_v4_test3.pgdx', 'detectors/clicktriggerbackground/clicktriggerbackground_v0_test1.pgdx', 'detectors/gpl/gpl_v2_test1.pgdx', 'detectors/gpl/gpl_v2_test2.pgdx', 'detectors/rwedge/RW_Edge_Detector_Right_Whale_Edge_Detector_Edges_20090328_230139.pgdx', 'detectors/whistleandmoan/whistleandmoan_v2_test1.pgdx', 'plugins/geminithreshold/geminithreshold_test1.pgdx', 'plugins/spermwhaleipi/spermwhaleipi_v1_test1.pgdx', 'processing/clipgenerator/clipgenerator_v3_test1.pgdx', 'processing/clipgenerator/clipgenerator_v3_test2.pgdx', 'processing/dbht/dbht_v2_test1.pgdx', 'processing/difar/difar_v2_test1.pgdx', 'processing/difar/difar_v2_test2.pgdx', 'processing/difar/difar_v2_test3.pgdx', 'processing/ishmael/ishmaeldetections_energysum_v2_test1.pgdx', 'processing/ishmael/ishmaeldetections_energysum_v2_test2.pgdx', 'processing/ishmael/ishmaeldetections_energysum_v2_test3.pgdx', 'processing/ishmael/ishmaeldetections_matchedfilter_v2_test1.pgdx', 'processing/ishmael/ishmaeldetections_matchedfilter_v2_test2.pgdx', 'processing/ishmael/ishmaeldetections_spectrogramcorrelation_v2_test1.pgdx', 'processing/ishmael/ishmaeldetections_spectrogramcorrelation_v2_test2.pgdx', 'processing/longtermspectralaverage/longtermspectralaverage_v2_test1.pgdx', 'processing/noiseband/noiseband_v3_test1.pgdx', 'processing/noiseband/noisebandnoise_v3_test1.pgdx', 'processing/noiseband/noisebandpulses_v3_test1.pgdx', 'processing/noisemonitor/noisemonitor_v2_test1.pgdx', ...
            'detectors/click/click_v4_test1.pgnf', 'detectors/click/click_v4_test2.pgnf', 'detectors/click/click_v4_test3.pgnf', 'detectors/gpl/gpl_v2_test1.pgnf', 'detectors/gpl/gpl_v2_test2.pgnf', 'detectors/whistleandmoan/whistleandmoan_v2_test1.pgnf', 'plugins/geminithreshold/geminithreshold_test1.pgnf'
            };
        end
    methods
        function [data, fileInfo] = runCur(obj, filename)
            rmpath(obj.oldLibName);
            addpath(genpath(obj.currentLibName));
            [data, fileInfo] = loadPamguardBinaryFile(filename);
        end
        function [data, fileInfo] = runOld(obj, filename)
            rmpath(obj.currentLibName);
            addpath(obj.oldLibName);
            [data, fileInfo] = loadPamguardBinaryFile(filename);
        end
    end


    methods(Test)
        function testFile(testCase, filePath)
            relFilePath = testCase.dataRootDir + "" + filePath;
            fprintf('Testing %s\n', relFilePath);

            tic;
            [newData, newFileInfo] = testCase.runCur(relFilePath);
            newTime = toc;
            
            tic;
            [oldData, oldFileInfo] = testCase.runOld(relFilePath);
            oldTime = toc;
            
            testCase.verifyEqual(newData, oldData);
            fields_to_remove = {'readModuleHeader', 'readModuleFooter', 'readBackgroundData', 'readModuleData'};
            for i = 1:length(fields_to_remove)
                if isfield(oldFileInfo, fields_to_remove{i})
                    oldFileInfo = rmfield(oldFileInfo, fields_to_remove{i});
                end
            end
            testCase.verifyEqual(newFileInfo, oldFileInfo);
            
            % Get file size
            fileSize = dir(relFilePath);
            fileSize = fileSize.bytes;
            
            % Write results to CSV file
            fid = fopen('results.csv', 'a');
            fprintf(fid, '%s,%d,%f,%f\n', relFilePath, fileSize, newTime, oldTime);
            fclose(fid);
        end
    end
end