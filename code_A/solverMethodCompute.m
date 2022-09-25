classdef solverMethodCompute < handle
    properties (Access = private)
        method
        KLL
        KRL
        KLR
        KRR

        FextL
        FextR
        
        uR
        vL
        
        vR
        
    end
    properties (Access = public)
        u
        R     
    end 
    methods (Access = public)
        function obj = solverMethodCompute(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.choser()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.method = cParams.method;
   
            obj.KLL =cParams.KLL;
            obj.KRL =cParams.KRL;
            obj.KLR =cParams.KLR;
            obj.KRR =cParams.KRR;

            obj.FextL =cParams.FextL;
            obj.FextR =cParams.FextR;

            obj.uR =cParams.uR;
            obj.vL =cParams.vL;
            obj.vR =cParams.vR;
        end
        function choser(obj)
            if obj.method == "direct"
                obj.directSolve();
            end
            if obj.method == "iterative"
                obj.iterativeSolve();
            end 
        end
        function directSolve(obj)

            s.KLL =obj.KLL;
            s.KRL =obj.KRL;
            s.KLR =obj.KLR;
            s.KRR =obj.KRR;

            s.FextL =obj.FextL;
            s.FextR =obj.FextR;

            s.uR =obj.uR;
            s.vL =obj.vL;
            s.vR =obj.vR;
            B = SolverStructureDirect(s);
            B.compute();
            obj.u = B.u;
            obj.R = B.R;

        end
        function iterativeSolve(obj)
            s.KLL =obj.KLL;
            s.KRL =obj.KRL;
            s.KLR =obj.KLR;
            s.KRR =obj.KRR;

            s.FextL =obj.FextL;
            s.FextR =obj.FextR;

            s.uR =obj.uR;
            s.vL =obj.vL;
            s.vR =obj.vR;
            B = SolverStructureIterative(s);
            B.compute();
            obj.u = B.u;
            obj.R = B.R;
        end 

    end 

end