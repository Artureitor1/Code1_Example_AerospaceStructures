classdef IterativeSolver < MatrixBsolver
    methods (Access = public)
        function solve(obj)
            obj.solveB();
        end
    end
    methods (Access = private)
        function solveB(obj)
            obj.splitedB.B= pcg(obj.splitedA.D,(obj.splitedC.B-obj.splitedA.C*obj.splitedB.A));
            obj.B(obj.splitedCondition.freeDegress,1)=obj.splitedB.B;
            obj.B(obj.splitedCondition.imposedDegress,1)=obj.splitedB.A;
        end 
    end 
end
