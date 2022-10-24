classdef DisplacementReactionComputer < handle 

    properties (Access = public)
        displacement
        reactionForces
    end
    properties (Access = private)
        stifnessMatrix  
        method
        restringedNodes 

        splitedCondition
        splitedStifnessMatrix
        splitedForce
        externalForces
    end

    methods (Access = public)
        function obj = DisplacementReactionComputer(cParams)
           obj.init(cParams);
        end

        function compute(obj)
           obj.computeSplit();
           obj.solveSystem();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.stifnessMatrix = cParams.stifnessMatrix;
            obj.externalForces = cParams.externalForces;
            obj.method = cParams.method;
            obj.restringedNodes = cParams.restringedNodes;
        end
        function computeSplit(obj)
            s.restringedNodes = obj.restringedNodes;
            s.stifnessMatrix     = obj.stifnessMatrix;
            s.externalForces = obj.externalForces;
            
            B = SplitComputer(s);
            B.compute()
            obj.splitedCondition = B.splitedCondition;
            obj.splitedStifnessMatrix = B.splitedStifnessMatrix;
            obj.splitedForce = B.splitedForce;
        end
        function solveSystem(obj)
            s.method = obj.method;
            s.splitedStifnessMatrix = obj.splitedStifnessMatrix;
            s.splitedForce = obj.splitedForce;
            s.splitedCondition = obj.splitedCondition;
            B = SystemSolver(s);
            B.compute()
            obj.displacement = B.B;
            obj.reactionForces = B.D;
        end
    end 
end