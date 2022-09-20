classdef conditionAsembler < handle
    properties (Access = public)
        uR
        vR
        vL
    end
    properties (Access = private)
        fixNod
    end 

    methods (Access = public)
        function obj = conditionAsembler(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.applyCond()
        end
    end
    methods  (Access = protected)
        function init(obj,cParams)
            obj.fixNod = cParams.fixNod;
        end

        function applyCond(obj)
            obj.uR = zeros(size(obj.fixNod,1),1);
            obj.vR = zeros(size(obj.fixNod,1),1);
            v = linspace(1,16,16);
            for i = 1:size(obj.uR,1)
                if (obj.fixNod(i,2))== 2
                    obj.vR(i,1) = 2*obj.fixNod(i,1);
                    obj.uR(i,1) = obj.fixNod(i,3);
                else
                    obj.vR(i,1) = 2*(obj.fixNod(i,1))-1;
                    obj.uR(i,1) = obj.fixNod(i,3);
                end
            end
            obj.vL = transpose (setdiff(v,obj.vR));
        end
    end
end