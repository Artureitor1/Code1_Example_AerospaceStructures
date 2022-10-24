classdef ForceComputer < handle
    properties (Access = public)
        externalForces
    end
    properties (Access = private)
        totalDegresFredom
        forceData  
    end 

    methods (Access = public)
        function obj = ForceComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeF()
        end
    end
    methods  (Access = protected)
        function init(obj,cParams)
            obj.totalDegresFredom = cParams.totalDegresFredom;
            obj.forceData = cParams.forceData;
        end

        function computeF(obj)
            externalForces = zeros(obj.totalDegresFredom,1);
            forceNode = obj.forceData(:,1);
            forceMagnitude = obj.forceData(:,3);
            
            for i=1:length(obj.forceData)
                if obj.forceData(i,2) == 2 
                    externalForces(forceNode(i)*2,1)=forceMagnitude(i);
                else
                    externalForces((forceNode(i)*2)-1,1)=forceMagnitude(i);
                end
            end
            obj.externalForces = externalForces;
        end
    end
end