@AbapCatalog.sqlViewName: 'ZBCTKTTTCUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@ObjectModel.representativeKey: 'Customer'
@ObjectModel.usageType.dataClass: #MASTER
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #S
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Search Help For Customer'
define view ZIM_BCTKTTT_CUS_SH
  as select from I_Customer
{
      @Search.defaultSearchElement: true
  key Customer,
      CustomerName,
      CustomerFullName
}
