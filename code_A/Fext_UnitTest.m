%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   UNIT TESTING SCRIPT Fext   %%%%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
%% Load the workspace of the expected results
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\Fext.mat')

%% Load the workspace of the example properties
load('C:\Users\artur\Documents\GitHub\Test1-AerospaceStructures1Example\code_A\Test\cParams.mat')

%% Create the objects
Test1 = SolverStructureDirect(cParams); %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one is used.
Test2 = SolverStructureIterative(cParams); %As SolverStructure is the father of the SolverStructureDirect and SolverStructureItertive. Doesnt matter wich one use.


%% Start the Solver of the objects

solver(Test1);
solver(Test2);

clc
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
clear