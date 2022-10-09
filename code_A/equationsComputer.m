classdef EquationsComputer < handle
    properties (Access = public)
        KG
        Fext
        
    end
    properties (Access = private)
        nEl
        Td
        x
        Tn
        Tmat
        mat
        Fdata 
 
        nDof   
          
        nElDof 

        
        Kel
    end 

    methods (Access = public)
        function obj = EquationsComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeGeometry();
            obj.computeStifnessMatrix();
            obj.computeKG();
            obj.forceAsembler();
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.x = cParams.x;
            obj.Tn = cParams.Tn;
            obj.Tmat = cParams.Tmat;
            obj.mat = cParams.mat;
            obj.Fdata = cParams.Fdata;
        end
        function computeGeometry(obj)
            s.x      = obj.x;
            s.Tn     = obj.Tn;
            B        = GeometryComputer(s);
            B.compute();
            obj.nDof = B.nDof;
            obj.nEl  = B.nEl;
            obj.nElDof = B.nElDof; 
            obj.Td = B.Td;
        end 
        function computeStifnessMatrix(obj)
            s.nEl    = obj.nEl;
            s.Tn     = obj.Tn;
            s.x      = obj.x;
            s.Tmat   = obj.Tmat;
            s.mat    = obj.mat;
            s.nElDof = obj.nElDof;
            s.Td     = obj.Td;
            B        = StifnessMatrixComputer(s);
            B.compute();
            obj.Kel  = B.Kel;
        end
        function computeKG(obj)
            s.nDof    = obj.nDof;
            s.nEl     = obj.nEl;
            s.Td      = obj.Td;
            s.Kel     = obj.Kel;
            B = KGcomputer(s);
            B.compute();
            obj.KG = B.KG;
        end 
        function forceAsembler(obj)
            s.nDof = obj.nDof ;
            s.Fdata =  obj.Fdata;
            B = ForceComputer(s);
            B.compute();
            obj.Fext = B.Fext;
        end 
    end 
end