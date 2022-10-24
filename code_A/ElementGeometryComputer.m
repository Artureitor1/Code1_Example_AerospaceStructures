classdef ElementGeometryComputer < handle 
    properties (Access = private)
        coordNode
        nodalConectivity
        element

    end
    properties (Access = public)
        lenght
        se
        ce

    end 

    methods (Access = public)
        function obj = ElementGeometryComputer(cParams)
            obj.init(cParams)
        end

        function compute(obj)
            obj.computeLenght()
        end
    end
    methods (Access = private)
        function init(obj,cParams)
            obj.coordNode = cParams.coordNode;
            obj.nodalConectivity =cParams.nodalConectivity;
            obj.element =cParams.element;
        end
        
        function computeLenght(obj)
            xCoordsFirstNode = obj.coordNode(obj.nodalConectivity(obj.element,1),1);
            yCoordsFirstNode = obj.coordNode(obj.nodalConectivity(obj.element,1),2);
            xCoordsSecondNode = obj.coordNode(obj.nodalConectivity(obj.element,2),1);
            yCoordsSecondNode = obj.coordNode(obj.nodalConectivity(obj.element,2),2);

            obj.lenght=sqrt((xCoordsSecondNode-xCoordsFirstNode)^2+(yCoordsSecondNode-yCoordsFirstNode)^2);
            obj.se=(yCoordsSecondNode-yCoordsFirstNode)/obj.lenght;
            obj.ce=(xCoordsSecondNode-xCoordsFirstNode)/obj.lenght;
        end
    end 
end