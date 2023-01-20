%I wouldn't know this code from Adam but let's go and try it.

filename = 'nbdRayfile.test';
fclose('all');
fid = fopen(filename, 'a');
fprintf(fid,'''Bellhop RayTracing''');
fprintf(fid, '\n%6.0f',freqVec);
fprintf(fid, '\n 1   1   1');
fprintf(fid, '\n 1000     1');
fprintf(fid, '\n0');
fprintf(fid, '\n28.014209999999999'); %FIX THIS, PLACEHOLDER DEPTH
% fprintf(fid, '\n %f', max(depth))
fprintf(fid, '\n ''rz'' ');  
fprintf(fid, '\n -20');
% fprintf(fid, '\n %f', ray.x);


fclose('all');

%Title

%Frequency

