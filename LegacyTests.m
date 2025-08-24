% test the outputs of pgmatlab code with legacy code to ensure
% consistent interface and data.

classdef LegacyTests < matlab.unittest.TestCase
    properties
        currentLibName = 'pgmatlab';
        oldLibName = 'pgmatlab_legacy'
    end
    properties (TestParameter)
        % filePath = {'./data/detectors/click/click_v4_test1.pgdf', './data/detectors/click/click_v4_test2.pgdf', './data/detectors/click/click_v4_test3.pgdf', './data/detectors/clicktriggerbackground/clicktriggerbackground_v0_test1.pgdf', './data/detectors/gpl/gpl_v2_test1.pgdf', './data/detectors/gpl/gpl_v2_test2.pgdf', './data/detectors/rwedge/RW_Edge_Detector_Right_Whale_Edge_Detector_Edges_20090328_230139.pgdf', './data/detectors/whistleandmoan/whistleandmoan_v2_test1.pgdf'};
        filePath = {'./data/processing/ais/ais_v1_test1.pgdf', './data/classifiers/deeplearningclassifier/deeplearningclassifier_v2_test1_detections.pgdf', './data/classifiers/deeplearningclassifier/deeplearningclassifier_v2_test1_models.pgdf', './data/detectors/click/click_v4_test1.pgdf', './data/detectors/click/click_v4_test2.pgdf', './data/detectors/click/click_v4_test3.pgdf', './data/detectors/clicktriggerbackground/clicktriggerbackground_v0_test1.pgdf', './data/detectors/gpl/gpl_v2_test1.pgdf', './data/detectors/gpl/gpl_v2_test2.pgdf', './data/detectors/rwedge/RW_Edge_Detector_Right_Whale_Edge_Detector_Edges_20090328_230139.pgdf', './data/detectors/whistleandmoan/whistleandmoan_v2_test1.pgdf', './data/plugins/geminithreshold/geminithreshold_test1.pgdf', './data/plugins/spermwhaleipi/spermwhaleipi_v1_test1.pgdf', './data/processing/clipgenerator/clipgenerator_v3_test1.pgdf', './data/processing/clipgenerator/clipgenerator_v3_test2.pgdf', './data/processing/dbht/dbht_v2_test1.pgdf', './data/processing/difar/difar_v2_test1.pgdf', './data/processing/difar/difar_v2_test2.pgdf', './data/processing/difar/difar_v2_test3.pgdf', './data/processing/ishmael/ishmaeldetections_energysum_v2_test1.pgdf', './data/processing/ishmael/ishmaeldetections_energysum_v2_test2.pgdf', './data/processing/ishmael/ishmaeldetections_energysum_v2_test3.pgdf', './data/processing/ishmael/ishmaeldetections_matchedfilter_v2_test1.pgdf', './data/processing/ishmael/ishmaeldetections_matchedfilter_v2_test2.pgdf', './data/processing/ishmael/ishmaeldetections_spectrogramcorrelation_v2_test1.pgdf', './data/processing/ishmael/ishmaeldetections_spectrogramcorrelation_v2_test2.pgdf', './data/processing/longtermspectralaverage/longtermspectralaverage_v2_test1.pgdf', './data/processing/noiseband/noiseband_v3_test1.pgdf', './data/processing/noiseband/noisebandnoise_v3_test1.pgdf', './data/processing/noiseband/noisebandpulses_v3_test1.pgdf', './data/processing/noisemonitor/noisemonitor_v2_test1.pgdf'};
    end
    methods
        function [data, fileInfo] = runCur(obj, filename)
            rmpath(obj.oldLibName);
            addpath(obj.currentLibName);
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
            tic;
            [newData, newFileInfo] = testCase.runCur(filePath);
            newTime = toc;
            
            tic;
            [oldData, oldFileInfo] = testCase.runOld(filePath);
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
            fileSize = dir(filePath);
            fileSize = fileSize.bytes;
            
            % Write results to CSV file
            fid = fopen('results.csv', 'a');
            fprintf(fid, '%s,%d,%f,%f\n', filePath, fileSize, newTime, oldTime);
            fclose(fid);
        end
    end
end