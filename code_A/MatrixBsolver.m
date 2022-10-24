classdef MatrixBsolver < handle 

    properties (Access = protected)
        method
        splitedA
        splitedC
        splitedCondition
    end 
    properties (Access = public)
        B
        splitedB
    end 

    methods
        function obj = MatrixBsolver(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.chose()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.splitedA = cParams.splitedA;
            obj.splitedB = cParams.splitedB;
            obj.splitedC = cParams.splitedC;
            obj.splitedCondition = cParams.splitedCondition;
            obj.method = cParams.method;
        end
        function chose(obj)
            if obj.method == "direct"
                obj.directSolve();
            end
            if obj.method == "iterative"
                obj.iterativeSolve();
            end 
        end
        function directSolve(obj)
            s.method = obj.method;
            s.splitedA = obj.splitedA;
            s.splitedB = obj.splitedB;
            s.splitedC = obj.splitedC;
            s.splitedCondition = obj.splitedCondition;
            B = DirectSolver(s);
            B.solve();
            obj.B = B.B;
            obj.splitedB = B.splitedB;

        end
        function iterativeSolve(obj)
            s.method = obj.method;
            s.splitedA = obj.splitedA;
            s.splitedB = obj.splitedB;
            s.splitedC = obj.splitedC;
            s.splitedCondition = obj.splitedCondition;
            B = IterativeSolver(s);
            B.solve();
            obj.B = B.B;
            obj.splitedB = B.splitedB;
        end 
    end 
end