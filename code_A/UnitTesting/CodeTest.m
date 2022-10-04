%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT   %%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
close all
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\KG.mat');
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\Fext.mat');
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_dir.mat');
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\u_iter.mat');

%% Load the workspace of the example properties
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\cParams.mat');


%% Create the objects
cParams.method  = "direct";
Test1 = structureComputer(cParams);
cParams.method  = "iterative";
Test2 = structureComputer(cParams);

%Test1 = SolverStructureDirect(cParams); %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one is used.
%Test2 = SolverStructureIterative(cParams); %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one use.

%% Check in Validation

valKG       = true;
valFext     = true;
valU_dir    = true;
valU_iter   = true;

%% Start the Solver of the objects

Test1.compute();
Test2.compute();


%% Validator
if valKG
    if Test1.KG == KG 
        disp('Stifness matrix OK!');
    else
        error('ERROR in Stifness matrix ');
    end
end

if valFext
    if Test1.Fext == Fext
        disp('Complete Forces OK!');
    else
        error('ERROR in Complete Forces');
    end
end

if valU_dir
    if Test1.u == u_dir
        disp('Displacement by direct method OK!');
    else
        error('ERROR in Displacement by direct method');
    end
end

if valU_iter
    if Test2.u == u_iter
        disp('Displacement by iterative method OK!');
    else
        error('ERROR in Displacement by iterative method');
    end
end
