classdef SplitStifnessMatrixcomputer < handle
    properties (Access = private)
        stifnessMatrix
        splitedCondition
        
    end
    properties (Access = public)
        splitedStifnessMatrix
    end 

    methods (Access = public)
        function obj = SplitStifnessMatrixcomputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.split();
        end
    end
    methods (Access = private)
        function init (obj,cParams)
            obj.stifnessMatrix = cParams.stifnessMatrix;
            obj.splitedCondition = cParams.splitedCondition;
        end
        function split(obj)
            obj.splitedStifnessMatrix.KLL=obj.stifnessMatrix(obj.splitedCondition.freeDegress,obj.splitedCondition.freeDegress);
            obj.splitedStifnessMatrix.KLR=obj.stifnessMatrix(obj.splitedCondition.freeDegress,obj.splitedCondition.imposedDegress);
            obj.splitedStifnessMatrix.KRL=obj.stifnessMatrix(obj.splitedCondition.imposedDegress,obj.splitedCondition.freeDegress);
            obj.splitedStifnessMatrix.KRR=obj.stifnessMatrix(obj.splitedCondition.imposedDegress,obj.splitedCondition.imposedDegress);
        end 
    end 
end