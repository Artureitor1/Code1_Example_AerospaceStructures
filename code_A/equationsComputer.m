classdef equationsComputer < handle
    properties (Access = public)
        KG
        Fext
        nEl
        Td
    end
    properties (Access = private)
        x
        Tn
        Tmat
        mat
        Fdata 
 
        ni  
        nDof   
        nNod   
        nElDof 

        
        Kel
    end 

    methods (Access = public)
        function obj = equationsComputer(cParams)
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
            B        = geometryComputer(s);
            B.compute();
            obj.ni   = B.ni;
            obj.nDof = B.nDof;
            obj.nEl  = B.nEl;
            obj.nNod   = B.nNod;
            obj.nElDof = B.nElDof;        
        end 
        function computeStifnessMatrix(obj)
            s.nEl    = obj.nEl;
            s.nNod   = obj.nNod;
            s.ni     = obj.ni;
            s.Tn     = obj.Tn;
            s.x      = obj.x;
            s.Tmat   = obj.Tmat;
            s.mat    = obj.mat;
            s.nElDof = obj.nElDof;
            B        = stifnessMatrixComputer(s);
            B.compute();
            obj.Td   = B.Td;
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
            B = forceComputer(s);
            B.compute();
            obj.Fext = B.Fext;
        end 
    end 
end