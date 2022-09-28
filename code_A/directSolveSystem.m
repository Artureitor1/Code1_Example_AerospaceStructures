classdef directSolveSystem < handle 
    properties (Access = private)
        A
        B
    end
    properties (Access = public)
        C
    end

    methods (Access = public)
        function obj = directSolveSystem(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.solve();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.A = cParams.A;
            obj.B = cParams.B;
        end
        function solve(obj)
            obj.C =(obj.A)\(obj.B);
        end

    end 

end