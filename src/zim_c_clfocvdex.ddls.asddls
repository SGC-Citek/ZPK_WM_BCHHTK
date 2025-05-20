@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_ClfnObjectCharcValueDEX'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZIM_C_CLFOCVDEX
  as select distinct from I_ClfnObjectCharcValueDEX
    inner join            I_ClfnCharacteristic on I_ClfnObjectCharcValueDEX.CharcInternalID = I_ClfnCharacteristic.CharcInternalID
{
  key    substring(I_ClfnObjectCharcValueDEX.ClfnObjectID,1,18)                          as Matnr,
  key    rtrim(ltrim(substring(I_ClfnObjectCharcValueDEX.ClfnObjectID,19,60) ,' '), ' ') as Batch,
  key    I_ClfnObjectCharcValueDEX.CharcValue,
  key    I_ClfnCharacteristic.Characteristic,
  key    I_ClfnObjectCharcValueDEX.CharcFromDate,
  key    I_ClfnObjectCharcValueDEX.CharcFromDecimalValue,
         I_ClfnObjectCharcValueDEX.CharcFromDecimalValue                                 as Z_HSQD
         //         round(fltp_to_dec( I_ClfnObjectCharcValueDEX.CharcFromDecimalValue as abap.dec( 23, 3 ) ), 2) as Z_HSQD


}
where
  I_ClfnObjectCharcValueDEX.ClassType = '023'
