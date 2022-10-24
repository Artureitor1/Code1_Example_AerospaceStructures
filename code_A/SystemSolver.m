classdef SystemSolver < handle
    %   [A][B]=[C]+[D]
    %
    %   [AA AB][BA] = [CA]+[DA]
    %   [AC AD][BB]   [CB] [0 ]

    properties (Access = private)
        method
        splitedA 
        splitedB 
        splitedC 
        splitedD 
        splitedCondition
    end
    properties (Access = public)
        B
        D
    end
    methods (Access = public)
        function obj = SystemSolver(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.solveMatrixB();
            obj.solveMatrixD();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.method = cParams.method;     
            obj.splitedA = struct('A',cParams.splitedStifnessMatrix.KRR,'B',cParams.splitedStifnessMatrix.KRL,'C',cParams.splitedStifnessMatrix.KLR,'D',cParams.splitedStifnessMatrix.KLL);
            obj.splitedB = struct('A',cParams.splitedCondition.displacementRestringedNodes,'B',NaN);
            obj.splitedC = struct('A',cParams.splitedForce.FextR,'B',cParams.splitedForce.FextL);
            obj.method = cParams.method;     
            obj.splitedCondition =cParams.splitedCondition;
        end
        function solveMatrixB(obj)
            s.splitedA = obj.splitedA;
            s.splitedB = obj.splitedB;
            s.splitedC = obj.splitedC;
            s.splitedCondition = obj.splitedCondition;
            s.method = obj.method;
            Solv = MatrixBsolver(s);
            Solv.compute();
            obj.B = Solv.B;
            obj.splitedB = Solv.splitedB;
        end
        function solveMatrixD(obj)
            
            s.splitedA = obj.splitedA;
            s.splitedB = obj.splitedB;
            s.splitedC = obj.splitedC;
            s.splitedCondition = obj.splitedCondition;
            Solv = MatrixDsolver(s);
            Solv.solve();
            obj.D = Solv.D;
            obj.splitedD = Solv.splitedD;

        end
    end

end



