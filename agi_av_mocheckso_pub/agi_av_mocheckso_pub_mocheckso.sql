SELECT
    id AS t_id,
    "RICSService" AS ricsservice,
    "RICSDate" AS ricsdate,
    "DatasetName" AS datasetname,
    "DatasetID" AS datasetid,
    "ILModel" AS ilmodel,
    "ILTopic" AS iltopic,
    "ILTable" AS iltable,
    "ErrorID" AS errorid,
    "ErrorCategory" AS errorcategory,
    "ErrorCount" AS errorcount,
    "BFSNr" AS bfsnr,
    "Kt" AS kt,
    "ErrorDescription" AS errordescription,
    "RICSProfile" AS ricsprofile,
    "ErrorX" AS errorx,
    "ErrorY" AS errory,
    "Geometrie" AS geometrie
FROM
    av_mocheckso.mocheckso
;