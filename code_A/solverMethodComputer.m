classdef solverMethodComputer < handle
%   [A][B]=[C]+[D]
%
%   [AA AB][BA] = [CA]+[DA]
%   [AC AD][BB]   [CB] [0 ]
%
   
    properties (Access = protected)
        method 
        AD
        AC
        AB
        AA

        CA
        CB
        
        BA
        BB
        
        DA

        vL
        vR
    end
    properties (Access = public)
        B
        D     
    end 
    methods (Access = public)
        function obj = solverMethodComputer(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.chose()
        end
    end
    methods (Access = private)
        function init(obj,cParams)

            obj.method = cParams.method;
            obj.AD =cParams.KLL;
            obj.AB =cParams.KRL;
            obj.AC =cParams.KLR;
            obj.AA =cParams.KRR;

            obj.CB =cParams.FextL;
            obj.CA =cParams.FextR;

            obj.BA =cParams.uR;
            obj.vL =cParams.vL;
            obj.vR =cParams.vR;
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
            s.KLL =obj.AD;
            s.KRL =obj.AB;
            s.KLR =obj.AC;
            s.KRR =obj.AA;

            s.FextL =obj.CB;
            s.FextR =obj.CA;

            s.uR =obj.BA;
            s.vL =obj.vL;
            s.vR =obj.vR;

            B = directSolverComputer(s);
            B.solve();

            obj.B = B.B;
            obj.D = B.D;
        end
        function iterativeSolve(obj)
            s.method = obj.method;
            s.KLL =obj.AD;
            s.KRL =obj.AB;
            s.KLR =obj.AC;
            s.KRR =obj.AA;

            s.FextL =obj.CB;
            s.FextR =obj.CA;

            s.uR =obj.BA;
            s.vL =obj.vL;
            s.vR =obj.vR;

            B = iterativeSolverComputer(s);
            B.solve();

            obj.B = B.B;
            obj.D = B.D;
        end 

    end 

end



