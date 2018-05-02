begin
  fname1 = "anal00031"
  fname2 = "SFC_31_20170923_19.000"
  f1     = addfile(fname1,"r")
  f2     = addfile(fname2,"r")

  print(f2)
  ;lat1 = f1->XLAT(0,:,:)
  ;lat2 = f2->g3_lat_0
  ;printVarSummary(lat1)
  ;printVarSummary(lat2)
  ;diff = lat2-lat1
  ;printMinMax(diff,0)
  ;print(f2)
end

