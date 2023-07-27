%I've separated the Gray's Reef moored receivers into 3 triangle homies.
%Run this after VUEexports or something, I dunno, tired. mooredReceivers

%The first triangle homie, fairest of them all, contains moorings 13,2,9,
%and 8, in the Southwest corner.

start1 = datetime(2019,12,21);   %Dec 21, 2019
end1   = datetime(2020,12,12);   %Dec 12, 2020, 358 days

index13 = isbetween(mooredReceivers{13}.DT,start1,end1);                %39IN,         63081
index2  = isbetween(mooredReceivers{2}.DT,start1,end1);                 %SURTASS_05IN, 63064
index9  = isbetween(mooredReceivers{9}.DT,start1,end1);                 %FS6,          63075 
index8  = isbetween(mooredReceivers{8}.DT,start1,end1);                 %STSNew2,      63074

triangle1{1}.DT          = mooredReceivers{13}.DT(index13);
triangle1{1}.DN          = mooredReceivers{13}.DN(index13);
triangle1{1}.detections  = mooredReceivers{13}.detections(index13);
triangle1{1}.which       = mooredReceivers{13}.which;

triangle1{2}.DT          = mooredReceivers{2}.DT(index2);
triangle1{2}.DN          = mooredReceivers{2}.DN(index2);
triangle1{2}.detections  = mooredReceivers{2}.detections(index2);
triangle1{2}.which       = mooredReceivers{2}.which;

triangle1{3}.DT          = mooredReceivers{9}.DT(index9);
triangle1{3}.DN          = mooredReceivers{9}.DN(index9);
triangle1{3}.detections  = mooredReceivers{9}.detections(index9);
triangle1{3}.which       = mooredReceivers{9}.which;

triangle1{4}.DT          = mooredReceivers{8}.DT(index8);
triangle1{4}.DN          = mooredReceivers{8}.DN(index8);
triangle1{4}.detections  = mooredReceivers{8}.detections(index8);
triangle1{4}.which       = mooredReceivers{8}.which;


[gc,gr] = groupcounts(triangle1{1}.detections);
[gc,gr] = groupcounts(triangle1{2}.detections);
[gc,gr] = groupcounts(triangle1{3}.detections);
[gc,gr] = groupcounts(triangle1{4}.detections);

figure()
plot(triangle1{1}.DT,triangle1{1}.detections);
edges = unique(triangle1{2}.which);
notSelf = triangle1{2}.detections ~= 63081;

figure()
histogram(triangle1{2}.detections(notSelf));

%The second triangle homie, brutish yet wise, contains moorings 5, 7, 1,
%11, and 4, to the Northwest.

start2 = datetime(2020,1,29);    %Jan 29, 2020
end2   = datetime(2020,10,05);   %Oct 05, 2020, 251 days

index5 = isbetween(mooredReceivers{5}.DT,start2,end2);          %FS17,        63068
index7  = isbetween(mooredReceivers{7}.DT,start2,end2);         %STSNew1,     63073
index1  = isbetween(mooredReceivers{1}.DT,start2,end2);         %SURTASSTN20, 63062
index11  = isbetween(mooredReceivers{11}.DT,start2,end2);       %34ALTOUT,    63079
index4  = isbetween(mooredReceivers{4}.DT,start2,end2);         %33OUT,       63067

triangle2{1}.DT          = mooredReceivers{5}.DT(index5);
triangle2{1}.DN          = mooredReceivers{5}.DN(index5);
triangle2{1}.detections  = mooredReceivers{5}.detections(index5);
triangle2{1}.which       = mooredReceivers{5}.which;

triangle2{2}.DT          = mooredReceivers{7}.DT(index7);
triangle2{2}.DN          = mooredReceivers{7}.DN(index7);
triangle2{2}.detections  = mooredReceivers{7}.detections(index7);
triangle2{2}.which       = mooredReceivers{7}.which;

triangle2{3}.DT          = mooredReceivers{1}.DT(index1);
triangle2{3}.DN          = mooredReceivers{1}.DN(index1);
triangle2{3}.detections  = mooredReceivers{1}.detections(index1);
triangle2{3}.which       = mooredReceivers{1}.which;

triangle2{4}.DT          = mooredReceivers{11}.DT(index11);
triangle2{4}.DN          = mooredReceivers{11}.DN(index11);
triangle2{4}.detections  = mooredReceivers{11}.detections(index11);
triangle2{4}.which       = mooredReceivers{11}.which;

triangle2{5}.DT          = mooredReceivers{4}.DT(index4);
triangle2{5}.DN          = mooredReceivers{4}.DN(index4);
triangle2{5}.detections  = mooredReceivers{4}.detections(index4);
triangle2{5}.which       = mooredReceivers{4}.which;

[gc,gr] = groupcounts(triangle2{1}.detections);
[gc,gr] = groupcounts(triangle2{2}.detections);
[gc,gr] = groupcounts(triangle2{3}.detections);
[gc,gr] = groupcounts(triangle2{4}.detections);
[gc,gr] = groupcounts(triangle2{5}.detections);


%And third, last and certainly the least,is Cerberus's third head; it
%doesn't defend Hell, it's mere existence embodies it because I ONLY HAVE
%DATA FROM 2 OF THE 5 MOORINGS. DUMB. 10 and 3 are spoken for.

start3 = datetime(2019,11,21);   %Nov 21, 2019
end3   = datetime(2020,12,15);   %Dec 15, 2020, 391 Days

index10  = isbetween(mooredReceivers{10}.DT,start3,end3);   %08ALTIN,  63076
index3  = isbetween(mooredReceivers{3}.DT,start3,end3);     %ROLDAN,   63066

triangle3{1}.DT         = mooredReceivers{10}.DT(index10);
triangle3{1}.DN          = mooredReceivers{10}.DN(index10);
triangle3{1}.detections  = mooredReceivers{10}.detections(index10);
triangle3{1}.which       = mooredReceivers{10}.which;

triangle3{2}.DT         = mooredReceivers{3}.DT(index3);
triangle3{2}.DN          = mooredReceivers{3}.DN(index3);
triangle3{2}.detections  = mooredReceivers{3}.detections(index3);
triangle3{2}.which       = mooredReceivers{3}.which;

[gc,gr] = groupcounts(triangle3{1}.detections);
[gc,gr] = groupcounts(triangle3{2}.detections);


%The riders, regal and noble yet ISOLATED in their existence, are moorings
%12 and 6. They remain bastions of hope between our triangles, standing as
%testaments to their strength and willpower.

start4  = datetime(2019,11,22);  %Nov 22, 2019
end4    = datetime(2020,11,24);  %Nov 24, 2020

index12  = isbetween(mooredReceivers{12}.DT,start4,end4);   %09T, 63080
index6  = isbetween(mooredReceivers{6}.DT,start4,end4);     %08C, 63070

triangle4{1}.DT         = mooredReceivers{12}.DT(index12);
triangle4{1}.DN          = mooredReceivers{12}.DN(index12);
triangle4{1}.detections  = mooredReceivers{12}.detections(index12);
triangle4{1}.which       = mooredReceivers{12}.which;

triangle4{2}.DT         = mooredReceivers{6}.DT(index6);
triangle4{2}.DN          = mooredReceivers{6}.DN(index6);
triangle4{2}.detections  = mooredReceivers{6}.detections(index6);
triangle4{2}.which       = mooredReceivers{6}.which;

[gc,gr] = groupcounts(triangle4{1}.detections);
[gc,gr] = groupcounts(triangle4{2}.detections);
