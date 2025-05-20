@Search.searchable: true
@ObjectModel.representativeKey: 'ewmwarehouse'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_IM_BCTKTTT_WHNT'
@EndUserText.label: 'Search Help For Warehouse Number'
@ObjectModel.usageType.dataClass: #MASTER
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #S

define custom entity zim_BCTKTTT_wh_sh

{
      @UI                      : {
          selectionField       : [{ position: 10 }],
          lineItem             : [{ position: 10 , importance: #MEDIUM } ] }
      @Search.defaultSearchElement: true
      @EndUserText.label       : 'Warehouse Number'
  key ewmwarehouse             : abap.char(4);
      @UI                      : {
       lineItem                : [{ position: 20 , importance: #MEDIUM } ] }
      @EndUserText.label       : 'Warehouse Number Text'
      ewmwarehouse_description : abap.char(40);

}
