classdef SplitComputer < handle

    properties (Access = public)
        splitedCondition
        splitedStifnessMatrix
        splitedForce
    end
    properties (Access = private)
        externalForces
        restringedNodes
        stifnessMatrix
    end 

    methods (Access = public)
        function obj = SplitComputer(cParams)
            obj.init(cParams)
        end
        function compute(obj)           
            obj.splitConditions()
            obj.splitStifnessMatrix()
            obj.splitFext()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.restringedNodes = cParams.restringedNodes;
            obj.stifnessMatrix = cParams.stifnessMatrix;
            obj.externalForces = cParams.externalForces;
            
        end 
        function splitConditions(obj)
            s.restringedNodes = obj.restringedNodes;
            B = SplitConditionComputer(s);
            B.compute()
            obj.splitedCondition = B.splitedCondition;
        end
        function splitStifnessMatrix(obj)
            s.stifnessMatrix = obj.stifnessMatrix;
            s.splitedCondition = obj.splitedCondition;
            B = SplitStifnessMatrixcomputer(s);
            B.compute();
            obj.splitedStifnessMatrix = B.splitedStifnessMatrix;

        end
        function splitFext(obj)
            s.stifnessMatrix    = obj.stifnessMatrix;
            s.splitedCondition = obj.splitedCondition;
            s.externalForces  = obj.externalForces;
            B = SplitExternalForceComputer(s);
            B.compute()
            obj.splitedForce = B.splitedForce;
           
        end
    end
end