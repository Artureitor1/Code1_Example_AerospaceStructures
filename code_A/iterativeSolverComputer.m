classdef IterativeSolverComputer < SolverMethodComputer
    methods (Access = public)
        function solve(obj)
            obj.solveSystem();
        end
    end
    methods (Access = protected)
        function solveSystem(obj)
                obj.BB = pcg(obj.AD,(obj.CB-obj.AC*obj.BA));
                obj.DA=obj.AA*obj.BA+obj.AB*obj.BB-obj.CA;
                
                obj.B(obj.vL,1)=obj.BB;
                obj.B(obj.vR,1)=obj.BA;
                
                obj.D(obj.vL,1) = 0;
                obj.D(obj.vR,1) = obj.DA;
        end
    end
end