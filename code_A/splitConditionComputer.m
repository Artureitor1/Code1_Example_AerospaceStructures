classdef SplitConditionComputer < handle
    properties (Access = public)
        splitedCondition 
    end
    properties (Access = private)
        restringedNodes
    end 

    methods (Access = public)
        function obj = SplitConditionComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.applyCond()
        end
    end
    methods  (Access = protected)
        function init(obj,cParams)
            obj.restringedNodes = cParams.restringedNodes;
        end

        function applyCond(obj)
            nodes = obj.restringedNodes(:,1);
            degree = obj.restringedNodes(:,2);
            magnitude = obj.restringedNodes(:,3);
            displacementRestringedNodes = zeros(size(obj.restringedNodes,1),1);
            imposedDegress = zeros(size(obj.restringedNodes,1),1);
            
            for i = 1:size(displacementRestringedNodes,1)
                if (degree(i))== 2
                    imposedDegress(i,1) = 2*nodes(i,1);
                    displacementRestringedNodes(i,1) = magnitude(i);
                else
                    imposedDegress(i,1) = 2*(nodes(i,1))-1;
                    displacementRestringedNodes(i,1) = magnitude(i);
                end
            end
            obj.splitedCondition.displacementRestringedNodes = displacementRestringedNodes;
            obj.splitedCondition.imposedDegress = imposedDegress;
            obj.splitedCondition.freeDegress = transpose (setdiff(linspace(1,16,16),obj.splitedCondition.imposedDegress));
        end
    end
end