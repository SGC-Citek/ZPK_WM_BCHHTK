@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum I_MATERIALSTOCKTIMESERIES'
define root view entity ZIM_C_SUM_MASTOCK
  as select from I_MaterialStockTimeSeries(P_StartDate : $session.system_date, P_EndDate:$session.system_date, P_PeriodType : 'D')

{
  key     Material,
  key     Plant,
  key     StorageLocation,
  key     Batch,
  key     InventorySpecialStockType, //9
          /////Special Stock Number
  key     case when InventorySpecialStockType = 'E' or InventorySpecialStockType = 'T'
            then concat_with_space( ltrim(SDDocument,'0'),  concat_with_space( '/' ,ltrim(SDDocumentItem,'0'),1),1)
            when InventorySpecialStockType = 'K' or InventorySpecialStockType = 'M' or InventorySpecialStockType = 'O'
            then  ltrim(Supplier,'0')
            when InventorySpecialStockType = 'Q'
            then   WBSElementInternalID
            when InventorySpecialStockType = 'V' or InventorySpecialStockType = 'W'
            then ltrim(Customer,'0')
            else ' '                                                                 end as SpecialStockNumber,
  key     InventoryStockType,
  key     MaterialBaseUnit,
          @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
          sum( MatlWrhsStkQtyInMatlBaseUnit )                                            as Quantity
}
where
      InventoryStockType <> '04'
  and InventoryStockType <> '05'
group by
  Material,
  Plant,
  StorageLocation,
  Batch,
  InventorySpecialStockType,
  SDDocument,
  SDDocumentItem,
  Supplier,
  WBSElementInternalID,
  Customer,
  InventoryStockType,
  MaterialBaseUnit
