classdef ForceComputer < handle
    properties (Access = public)
        Fext
    end
    properties (Access = private)
        nDof
        Fdata  
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
            obj.nDof = cParams.nDof;
            obj.Fdata = cParams.Fdata;
        end

        function computeF (obj)
            obj.Fext=zeros(obj.nDof,1);
            for i=1:length(obj.Fdata)
                if obj.Fdata(i,2) == 2 % even case
                    obj.Fext(obj.Fdata(i,1)*2,1)=obj.Fdata(i,3);
                else
                    obj.Fext((obj.Fdata(i,1)*2)-1,1)=obj.Fdata(i,3); %odd case
                end
            end
        end
    end
end