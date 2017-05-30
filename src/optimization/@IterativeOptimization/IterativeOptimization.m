classdef IterativeOptimization < SeqOptimization
    %ITERATIVEOPTIMIZATION Optimize a set of qMT acquisitions iteratively.
    %
    %   --Initialization--
    %
    %   --Methods--
    %

    properties (Access = protected)
        metricSet = {'CRLB'}; % Valid optimization metrics

        minimMetric
        normalizationFlag = 'Normalized';
        
        fitParams
        fitParamsValues
        fitParamJacobian
        
        b1Params
        b1ParamsJacobian
        
        rankedAcqPoints % Default is 0s
        metricValsAcqPoints % Default is nan;
    end

    methods (Access = public)
        % Constructor
        function obj = IterativeOptimization(SeqJacobian_Obj, opts)
            obj = obj@SeqOptimization(SeqJacobian_Obj, opts);
                        
            % Save initializer args
            obj.jacobianObj = SeqJacobian_Obj;
            obj.opts = opts;
            
            % Set opts
            obj.fitParams = obj.opts.fitParams;
            if isfield(opts,'b1Params')
                obj.b1Params = obj.opts.b1Params;
                obj.setB1ParamsJacobian();
            end
            
            % Set properties
            obj.setFitParamJacobian();
            obj.setFitParamsValues();
            obj.resetRankedAcqPoints();
            obj.resetMetricValsAcqPoints();
        end

        % Compute methods
        computeSingle(obj, metricFlag)
        
        % Get Methods
        rankedAcqPoints = getRankedAcqPoints(obj)
        metricValsAcqPoints  = getMetricValsAcqPoints(obj)
    end
    
    methods (Access = protected)
       setFitParamJacobian(obj)
       setB1ParamsJacobian(obj)
       resetRankedAcqPoints(obj)
       resetMetricValsAcqPoints(obj)
       
       
       [jacobianSubset, acqPointRows] = getJacobianSubset(obj)
       minValue = findMinDeltaMetricVal(obj, metricValues)
       metricValues = calcMetricFor_N_Minus_1_Subsets(obj,jacobianSubset)
    end

    methods (Static, Access = public)
    end

end

