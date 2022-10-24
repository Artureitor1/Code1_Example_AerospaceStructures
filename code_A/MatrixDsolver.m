classdef MatrixDsolver < handle  
    properties (Access = private)
        splitedA
        splitedB
        splitedC
        splitedCondition
    end
    properties (Access = public)
        D
        splitedD

    end 

    methods
        function obj = MatrixDsolver(cParams)
            obj.init(cParams);
        end

        function solve(obj)
            obj.solveD()
        end
    end
    methods (Access = private)
        function init (obj,cParams)
            obj.splitedA = cParams.splitedA;
            obj.splitedB = cParams.splitedB;
            obj.splitedC = cParams.splitedC;
            obj.splitedCondition = cParams.splitedCondition;
        end 
        function solveD(obj)
            obj.splitedD.A=obj.splitedA.A*obj.splitedB.A+obj.splitedA.B*obj.splitedB.B-obj.splitedC.A;
            obj.D(obj.splitedCondition.freeDegress,1) = 0;
            obj.D(obj.splitedCondition.imposedDegress,1) = obj.splitedD.A;
        end
    end
end