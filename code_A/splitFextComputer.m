classdef splitFextComputer < handle
    properties (Access = private)
        vL
        vR
        Fext
    end
    properties (Access = public)
        FextR
        FextL
    end 

    methods (Access = public)
        function obj = splitFextComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.split();
        end
    end
    methods (Access = private)
        function init (obj,cParams)
            obj.Fext = cParams.Fext;
            obj.vL = cParams.vL;
            obj.vR = cParams.vR;
        end
        function split(obj)
            obj.FextL=obj.Fext(obj.vL,1);
            obj.FextR=obj.Fext(obj.vR,1);
        end 
    end 
end