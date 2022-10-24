classdef StructureComputer < handle

    properties (Access = private)
        data
        structure
        geometry
        reactionForces
        stress
        strain
    end
    properties (Access = public)
        displacement
        stifnessMatrix
        bucklingFailure
        externalForces
    end

    methods (Access = public)
        function obj = StructureComputer(cParams)
            obj.init(cParams);
        end
        function compute(obj)
            obj.computeGeometry
            obj.computeStifnessMatrix
            obj.computeForces
            obj.computeDisplacementReaction();
            obj.computeStrainStress();
            obj.computeBucklingFailure();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.inputData(cParams);
            obj.inputStructure(cParams);
        end
        function inputData(obj,cParams)
            obj.data.F               = cParams.F;
            obj.data.Young           = cParams.Young;
            obj.data.Area            = cParams.Area;
            obj.data.thermalCoeff    = cParams.thermal_coeff;
            obj.data.Inertia         = cParams.Inertia;
            obj.data.method          = cParams.method;
        end
        function inputStructure(obj,cParams)
            obj.structure.forceData         = cParams.Fdata;
            obj.structure.forceData(:,3)    = cParams.Fdata(:,3) * obj.data.F;
            obj.structure.coordNodes        = cParams.x;
            obj.structure.nodalConectivity  = cParams.Tn;
            obj.structure.restringedNodes   = cParams.fixNod;
            obj.structure.Tmat              = cParams.Tmat;
            obj.structure.mat               = [obj.data.Young,obj.data.Area,obj.data.thermalCoeff,obj.data.Inertia];
        end
        function computeGeometry(obj)
            s.coordNodes        = obj.structure.coordNodes;
            s.nodalConectivity  = obj.structure.nodalConectivity;
            B = GeometryComputer(s);
            B.compute()
            obj.geometry        = B.geometry;
        end
        function computeStifnessMatrix(obj)
            s.geometry = obj.geometry;
            s.structure = obj.structure;
            B = StifnessMatrixComputer(s);
            B.compute();
            obj.stifnessMatrix = B.stifnessMatrix;
        end
        function computeForces(obj)
            s.totalDegresFredom  = obj.geometry.totalDegresFredom;
            s.forceData =  obj.structure.forceData;
            B = ForceComputer(s);
            B.compute();
            obj.externalForces = B.externalForces;
        end
        function computeDisplacementReaction(obj)
            s.stifnessMatrix = obj.stifnessMatrix;
            s.externalForces = obj.externalForces;
            s.method = obj.data.method;
            s.restringedNodes = obj.structure.restringedNodes;

            B = DisplacementReactionComputer(s);
            B.compute()
            obj.displacement = B.displacement;
            obj.reactionForces = B.reactionForces;
        end

        function computeStrainStress(obj)
            s.nodalConectivity = obj.structure.nodalConectivity;
            s.coordNodes = obj.structure.coordNodes;
            s.mat = obj.structure.mat;
            s.Tmat = obj.structure.Tmat;
            s.displacement = obj.displacement;
            s.numberElement = obj.geometry.numberElement;
            s.degressConectivity = obj.geometry.degressConectivity;
            B = StressStrainComputer(s);
            B.compute();
            obj.strain = B.strain;
            obj.stress = B.stress;
        end

        function computeBucklingFailure(obj)
            s.coordNodes = obj.structure.coordNodes;
            s.nodalConectivity = obj.structure.nodalConectivity;
            s.mat = obj.structure.mat;
            s.Tmat = obj.structure.Tmat;
            s.stress = obj.stress;
            s.numberElement = obj.geometry.numberElement;
            B = BucklingFailureComputer(s);
            B.compute();
            obj.bucklingFailure = B.bucklingFailure;
        end

        %         function ploter(obj)
        %             s.Tn = obj.Tn;
        %             s.n =obj.n;
        %             s.x =obj.x;
        %             s.nd =obj.nd;
        %             s.u =obj.u;
        %             s.sig =obj.sig;
        %             B = plotCompute(s);
        %             B.compute();
        %         end
    end

end


