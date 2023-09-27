lib = lsl_loadlib();
info = lsl_streaminfo(lib,'AV_Demo','Markers',1,0,'cf_string','myuniquesourceid23443');
outlet = lsl_outlet(info);
for ii=1:20
    
    markers = {'AVDEMO'}
    outlet.push_sample(markers);
    pause(10)
    
end
