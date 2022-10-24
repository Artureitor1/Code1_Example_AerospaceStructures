classdef MatrixRotationComputer < handle
    properties (Access = private)
        coordNodes
        nodalConectivity
        element
        
    end
    properties (Access = public)
        lenght
        rotationMatrix
    end

    methods (Access = public)
        function obj = MatrixRotationComputer(cParams)
            obj.init(cParams);
        end

        function compute(obj)
            obj.computeMatrixRotation()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.coordNodes = cParams.coordNodes;
            obj.nodalConectivity = cParams.nodalConectivity;
            obj.element = cParams.element;
                
        end 
        function computeMatrixRotation(obj)

            [obj.lenght,se,ce] = obj.computeElementGeometry(obj.coordNodes,obj.nodalConectivity,obj.element);

            obj.rotationMatrix=[ce se 0 0
                -se ce 0 0
                0 0 ce se
                0 0 -se ce];
        end
    end
    methods (Access = private,Static)
        function [lenght,se,ce] = computeElementGeometry(coordNodes,nodalConectivity,element)
            s.coordNode = coordNodes;
            s.nodalConectivity = nodalConectivity;
            s.element = element;
            B = ElementGeometryComputer(s);
            B.compute;
            se = B.se;
            ce = B.ce;
            lenght = B.lenght;
        end 
    end 
    
end