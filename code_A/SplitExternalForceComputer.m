classdef SplitExternalForceComputer < handle
    properties (Access = private)
        splitedCondition
        externalForces
    end
    properties (Access = public)
        splitedForce
    end 

    methods (Access = public)
        function obj = SplitExternalForceComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.split();
        end
    end
    methods (Access = private)
        function init (obj,cParams)
            obj.externalForces = cParams.externalForces;
            obj.splitedCondition = cParams.splitedCondition;
        end
        function split(obj)
            obj.splitedForce.FextL=obj.externalForces(obj.splitedCondition.freeDegress,1);
            obj.splitedForce.FextR=obj.externalForces(obj.splitedCondition.imposedDegress,1);
        end 
    end 
end