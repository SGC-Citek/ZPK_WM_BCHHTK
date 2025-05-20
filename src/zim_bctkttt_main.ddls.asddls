@EndUserText.label: 'Báo cáo tồn kho theo thuộc tính'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_IM_BCTKTTT'
@UI: {
 headerInfo: { typeName: 'Báo cáo tồn kho theo thuộc tính', typeNamePlural: 'Báo cáo tồn kho theo thuộc tính  ' } ,
 presentationVariant: [{groupBy: [ 'Material'],
                        initialExpansionLevel: 1,
                        visualizations: [{
                            element: 'ProductName'
                        }],
                        requestAtLeast: [ 'Material' ]
                      }]
       }
define custom entity ZIM_BCTKTTT_MAIN
{
      ///////////////////////KEY CHUNG///////////////////////////////////////////////
      @UI                           : {
      selectionField                : [{ position: 30 }],
      lineItem                      : [{ position: 50 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_ProductStdVH', element: 'Product' } } ]
      @EndUserText.label            : 'Material'
  key Material                      : matnr;
      @UI                           : {
       selectionField               : [{ position: 10 }],
       lineItem                     : [{ position: 10 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
      @EndUserText.label            : 'Plant'
  key Plant                         : werks_d;
      @UI                           : {
       selectionField               : [{ position: 60 }],
       lineItem                     : [{ position: 70 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_BatchStdVH', element: 'Batch' } } ]
      @EndUserText.label            : 'Batch'
  key Batch                         : charg_d;
      @UI.hidden                    : true
  key P_OTP_DIS                     : abap.char(2);
      ///////////////////////KEY Xem tồn kho không vị trí///////////////////////////////////////////////
      @UI                           : {
      selectionField                : [{ position: 20 }],
      lineItem                      : [{ position: 30 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_StorageLocationStdVH', element: 'StorageLocation' } } ]
      @EndUserText.label            : 'Storage location'
  key StorageLocation               : lgort_d_edi_ext;
      @UI                           : {
        lineItem                    : [{ position: 90 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Special Stock Number'
  key SpecialStockNumber            : abap.char(24);
      @UI                           : {
          selectionField            : [{ position: 90 }],
          lineItem                  : [{ position: 80 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_InventorySpecialStockType', element: 'InventorySpecialStockType' } } ]
      @EndUserText.label            : 'Special stock'
  key InventorySpecialStockType     : abap.char(1);
      ///////////////////////KEY Xem tồn kho vị trí///////////////////////////////////////////////
  key ParentHandlingUnitUUID        : zde_guid_parent;
  key StockItemUUID                 : zde_guid_stock;
      @UI                           : {
        selectionField              : [{ position: 120 }],
        lineItem                    : [{ position: 30 , importance: #MEDIUM } ] }
      @Search.defaultSearchElement  : true
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zim_BCTKTTT_wh_sh', element: 'ewmwarehouse'  } }]
      @EndUserText.label            : 'Warehouse Number'
  key EWMWarehouse                  : abap.char(4);
      @UI                           : {
        selectionField              : [{ position: 130 }],
        lineItem                    : [{ position: 40 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZWM_I_STORAGETYPE_SH', element: 'ewmstorage_type' } }]
      @EndUserText.label            : 'Storage Type'
  key EWMStorageType                : abap.char(4);
      @UI                           : {
           selectionField           : [{ position: 140 }],
           lineItem                 : [{ position: 50 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZWM_I_STORAGEBINCUBE_SH', element: 'ewmstorage_bin' } }]
      @EndUserText.label            : 'Storage Bin'
  key EWMStorageBin                 : abap.char(18);
      @Consumption.valueHelpDefinition:[ { entity: { name: 'ZI_EWM_SDK2D_STG_SH', element: 'StorageGroup' } } ]
      @UI                           : {
      selectionField                : [{ position: 170  }],
      lineItem                      : [{ position: 55 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Storage Group'
      EWMStorageGroup               : zde_lgber_lgst;
      ///////////////////////FIELD CHUNG///////////////////////////////////////////////
      @ObjectModel.text.element     : [ 'UuidStatusName' ]
      @UI.lineItem                  : [{ position: 9, criticalityRepresentation: #WITH_ICON , criticality: 'UuidStatusCritical' }]
      //      @UI.fieldGroup                : [{ qualifier: 'documentInfo', position: 1, criticalityRepresentation: #WITH_ICON , criticality: 'UuidStatusCritical' }]
      UuidStatus                    : zde_bctkttt_status;
      @UI.hidden                    : true
      UuidStatusCritical            : abap.int1;
      @UI.hidden                    : true
      UuidStatusName                : abap.char(20);
      @UI                           : {
      selectionField                : [{ position: 40 }],
      lineItem                      : [{ position: 100 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_ProductTypeText_2', element: 'ProductType' }, additionalBinding: [{
                                            element: 'Language', localConstant: 'E', usage: #FILTER }] } ]
      @EndUserText.label            : 'Material type'
      ProductType                   : abap.char(4);
      @UI                           : {
      lineItem                      : [{ position: 110 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Material Type Description'
      ProductTypeName               : abap.char(25);
      @UI                           : {
      selectionField                : [{ position: 50 }],
      lineItem                      : [{ position: 120 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_ProductGroupText_2', element: 'ProductGroup' } ,
      additionalBinding             : [{element: 'Language', localConstant: 'E',usage: #FILTER  }]} ]
      @EndUserText.label            : 'Material Group'
      ProductGroup                  : abap.char(9);
      @UI                           : {
      lineItem                      : [{ position: 130 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Material Group Desc.'
      ProductGroupName              : abap.char(20);
      @UI                           : {
      lineItem                      : [{ position: 60 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Material Description'
      ProductName                   : abap.char(40);
      @UI                           : {
      lineItem                      : [{ position: 20 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Plant Name'
      PlantName                     : abap.char(30);
      @UI                           : {
      lineItem                      : [{ position: 40 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Storage Location Name'
      StorageLocationName           : abap.char(16);
      @UI                           : {
      lineItem                      : [{ position: 380 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Ngày nhập kho'
      NgayNhapKho                   : abap.dats(8);
      @UI                           : {
      lineItem                      : [{ position: 390 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Ngày sản xuất'
      NgaySanXuat                   : abap.dats(8);
      @UI                           : {
      lineItem                      : [{ position: 400 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Hạn sử dụng'
      HanSuDung                     : abap.dats(8);
      @UI                           : {
      lineItem                      : [{ position: 410 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Đơn vị sản xuất'
      DonViSanXuat                  : abap.char(70);
      @ObjectModel.text.element     : [ 'NameNhaCungCap' ]
      @UI                           : {
      lineItem                      : [{ position: 420 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_Supplier_VH', element: 'Supplier' } }]
      @EndUserText.label            : 'Nhà cung cấp'
      NhaCungCap                    : abap.char(70);
      @UI.hidden                    : true
      @Consumption.filter.hidden    : true
      NameNhaCungCap                : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 430 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Ghi chú lô'
      GhiChu                        : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 430 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Ghi chú HU'
      GhiChuHU                      : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 440 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Số lot'
      SoLot                         : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 440 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Loại vụn'
      ZVun                          : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 440 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Số hợp đồng'
      SoHopDong                     : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 440 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Mã Truy xuất'
      MaTruyXuat                    : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 450 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Ca sản xuất'
      CaSanXuat                     : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 460 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Nguồn gốc sản phẩm'
      NguonGocSanPham               : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 460 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'HSQD'
      HSQD                          : abap.dec( 23, 3 );
      @UI                           : {
      lineItem                      : [{ position: 470 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Chứng nhận'
      Chungnhan                     : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 480 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Dòng sản phẩm'
      Dongsanpham                   : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 490 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Gia vị/ phụ gia'
      GiaviPhugia                   : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 500 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Kích cỡ/ Hình dáng/ Size'
      KichcoHinhdangSize            : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 510 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Loại hình sản xuất'
      Loaihinhsanxuat               : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 520 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Loại TP thu hồi'
      LoaiTPthuhoi                  : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 530 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Quy cách đóng gói chuẩn'
      Quycachdonggoi                : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 560 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Chất lượng cảm quan'
      ChatLuongCamQuan              : abap.char(55);
      @UI                           : {
      lineItem                      : [{ position: 570 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Chỉ tiêu định lượng'
      ChiTieuDinhLuong              : abap.char(55);


      @UI                           : {
      lineItem                      : [{ position: 590 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Khách hàng gửi gia công'
      ViTri                         : abap.char(70);
      @UI                           : {
      lineItem                      : [{ position: 580 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'HU SAP'
      HuSAP                         : abap.char(55);


      ///////////////////////FIELD Xem tồn kho không vị trí///////////////////////////////////////////////
      @UI                           : {
      selectionField                : [{ position: 100 }],
      lineItem                      : [{ position: 290 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'I_SalesDocumentStdVH', element: 'SalesDocument' } } ]
      @EndUserText.label            : 'Sales document'
      SDDocument                    : zde_vbeln;
      @UI                           : {
      lineItem                      : [{ position: 300 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'SD Document Item'
      SDDocumentItem                : abap.numc(6 );
      @UI                           : {
      selectionField                : [{ position: 110 }],
      lineItem                      : [{ position: 270 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition:[ { entity: { name: 'ZIM_BCTKTTT_CUS_SH', element: 'Customer' } } ]
      @EndUserText.label            : 'Customer'
      Customer                      : zde_kunnr;
      @UI                           : {
      lineItem                      : [{ position: 280 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Customer name'
      CustomerName                  : abap.char(80);
      @UI                           : {
      lineItem                      : [{ position: 250 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Vendor'
      Supplier                      : lifnr;
      @UI                           : {
      lineItem                      : [{ position: 260 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Vendor name'
      SupplierName                  : abap.char(80);
      @UI                           : {
       lineItem                     : [{ position: 240 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Base unit of measure (BUn)'
      MaterialBaseUnit              : abap.unit( 3 );
      Currency                      : abap.cuky( 5 );
      @Aggregation.default          : #SUM
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 140 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Unrestricted'

      Unrestricted                  : abap.dec( 13, 2 ); //14 Unrestricted
      //      @Semantics.amount.currencyCode: 'Currency'
      //      @UI                           : {
      //      lineItem                      : [{ position: 190 , importance: #MEDIUM } ] }
      //      @EndUserText.label            : 'Value Unrestricted'
      //      ValueUnrestricted             : abap.curr( 23, 2 );
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 150 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Blocked'
      @Aggregation.default          : #SUM
      Blocked                       : abap.dec( 13, 2 ); //15 Blocked
      //      @Semantics.amount.currencyCode: 'Currency'
      //      @UI                           : {
      //      lineItem                      : [{ position: 200 , importance: #MEDIUM } ] }
      //      @EndUserText.label            : 'Value BlockedStock'
      //      ValueBlocked                  : abap.curr( 23, 2 );
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 160 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Transit and Tranfer'
      @Aggregation.default          : #SUM
      TransitAndTranfer             : abap.dec(13, 2 ); //16 Transit and Tranfer
      //      @Semantics.amount.currencyCode: 'Currency'
      //      @UI                           : {
      //      lineItem                      : [{ position: 210 , importance: #MEDIUM } ] }
      //      @EndUserText.label            : 'Val. in Trans./Tfr'
      //      ValueTransitAndTranfer        : abap.curr( 23, 2 );
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 170 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Returns'
      @Aggregation.default          : #SUM
      Returns                       : abap.dec(13,2); //17 Returns
      //      @Semantics.amount.currencyCode: 'Currency'
      //      @UI                           : {
      //      lineItem                      : [{ position: 220 , importance: #MEDIUM } ] }
      //      @EndUserText.label            : 'Value Rets Blocked'
      //      ValueReturns                  : abap.curr( 23, 2 );
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 180 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Quality Inspection'
      @Aggregation.default          : #SUM
      QualityInspection             : abap.dec(13,2); //18 Quality Inspection
      //      @Semantics.amount.currencyCode: 'Currency'
      //      @UI                           : {
      //      lineItem                      : [{ position: 220 , importance: #MEDIUM } ] }
      //      @EndUserText.label            : 'Value in QualInsp.'
      //      ValueQualityInspection        : abap.curr( 23, 2 );
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @Aggregation.default          : #SUM
      @UI                           : {
      lineItem                      : [{ position: 490 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Unrestricted-Use (THU)'
      UnrestrictedUse               : abap.dec( 13, 2 ); //14 UnrestrictedUse
      //      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @Aggregation.default          : #SUM
      @UI                           : {
      lineItem                      : [{ position: 490 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Blocked (THU)'
      BlockedThu                    : abap.dec( 13, 2 ); //14 Blocked (THU)

      ///////////////////////FIELD Xem tồn kho vị trí///////////////////////////////////////////////
      @UI                           : {
      lineItem                      : [{ position: 150 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Stock Type Description'
      EWMStockTypeName              : abap.char(30);
      @UI                           : {
      selectionField                : [{ position: 180 }],
      lineItem                      : [{ position: 140 , importance: #MEDIUM } ] }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZWM_I_EWMStockType_SH', element: 'ewmstock_type'  } }]
      @EndUserText.label            : 'Stock Type'
      EWMStockType                  : abap.char(2);
      @UI                           : {
      lineItem                      : [{ position: 160 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Owner'
      EWMStockOwner                 : zde_kunnr;
      @UI                           : {
      lineItem                      : [{ position: 170 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Party Entitled to Dispose'
      EntitledToDisposeParty        : zde_kunnr;
      @UI                           : {
      lineItem                      : [{ position: 180 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Special Reference Stock Type'
      StockDocumentCategory         : abap.char(3);
      @UI                           : {
      lineItem                      : [{ position: 190 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Sales document'
      StockDocumentNumber           : zde_ewm_stockdocumentnumber;
      @UI                           : {
      lineItem                      : [{ position: 190 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Sls Order Item'
      StockItemNumber               : abap.numc( 10 );
      @UI                           : {
      lineItem                      : [{ position: 200 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Reference Document Category'
      EWMStockReferenceDocCategory  : abap.char(3);
      @UI                           : {
      lineItem                      : [{ position: 210 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Reference Document'
      EWMStockReferenceDocument     : zde_ewm_stockdocumentnumber;
      @UI                           : {
      lineItem                      : [{ position: 220 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Reference Document Item'
      EWMStockReferenceDocumentItem : abap.numc( 10 );
      @Semantics.quantity.unitOfMeasure: 'EWMLoadingOrNetWeightUnit'
      @UI                           : {
      lineItem                      : [{ position: 230 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Loading or Net Weight'
      EWMLoadingOrNetWeight         : abap.quan( 15, 3 );
      @UI                           : {
      lineItem                      : [{ position: 260 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Weight Unit'
      EWMLoadingOrNetWeightUnit     : abap.unit( 3 );
      @Semantics.quantity.unitOfMeasure: 'EWMLoadingOrNetVolumeUnit'
      @UI                           : {
      lineItem                      : [{ position: 240 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Loading or Net Volume'
      EWMLoadingOrNetVolume         : abap.quan(15, 3 );
      @UI                           : {
      lineItem                      : [{ position: 250 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Volume Unit'
      EWMLoadingOrNetVolumeUnit     : abap.unit( 3 );
      @UI                           : {
      lineItem                      : [{ position: 270 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Handling Unit'
      HandlingUnitNumber            : zde_ewm_huident;
      @UI                           : {
      lineItem                      : [{ position: 270 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Pallet No'
      palletno                      : abap.char(100);
      @UI                           : {
      lineItem                      : [{ position: 280 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Highest-Level Handling Unit'
      EWMHghstLvlHandlingUnitNumber : zde_ewm_huident;
      @UI                           : {
      lineItem                      : [{ position: 290 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Goods Receipt Date'
      EWMGoodsReceiptDateTime       : tzntstmps;
      @UI                           : {
      lineItem                      : [{ position: 300 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Shelf Life Expiration Date'
      ShelfLifeExpirationDate       : abap.dats;
      @Aggregation.default          : #SUM
      //      @Semantics.quantity.unitOfMeasure: 'EWMStockQuantityBaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 340 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Total Stock'
      EWMStockQuantityInBaseUnit    : abap.dec(31,2);
      @Aggregation.default          : #SUM
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 540 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Total Stock (THU)'
      EWMStockQuantityInBaseUnitTHU : abap.dec( 31, 2 );
      @Aggregation.default          : #SUM
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 550 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Available Stock (THU)'
      AvailableEWMStockQtyTHU       : abap.dec( 31, 2 );
      @Aggregation.default          : #SUM
      //      @Semantics.quantity.unitOfMeasure: 'EWMStockQuantityBaseUnit'
      @UI                           : {
      lineItem                      : [{ position: 340 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Available Stock'
      AvailableEWMStockQty          : abap.dec(31, 2 );
      @UI                           : {
      lineItem                      : [{ position: 310 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Base Unit of Measure'
      EWMStockQuantityBaseUnit      : abap.unit( 3 );
      @UI                           : {
      lineItem                      : [{ position: 320 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Storage Bin Block Put away'
      EWMStorBinIsBlockedForPutaway : abap.char( 1 );
      @UI                           : {
      lineItem                      : [{ position: 320 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Storage Bin Block Removal'
      EWMStorBinIsBlockedForRemoval : abap.char( 1 );
      @UI                           : {
      selectionField                : [{ position: 200 }] }
      @Consumption.filter.selectionType: #SINGLE
      //      @Consumption.filter.mandatory : true
      @EndUserText.label            : 'Ngày cảnh báo'
      NgayCanhBao                   : abap.int4;
      @UI                           : {
      lineItem                      : [{ position: 560 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'VHC Contract Number'
      YY1_VHCContractNumber_SDH     : abap.char(80);
      @UI                           : {
      lineItem                      : [{ position: 580 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'SoldToParty'
      SoldToPartyName               : abap.char(100);
      @UI                           : {
          lineItem                  : [{ position: 70 , importance: #MEDIUM } ] }
      @EndUserText.label            : 'Tên Dài'
      MaterialBasicText             : abap.char(100);
      /////
      BaseUnit                      : abap.unit( 3 );
      QuantityNumerator             : abap.dec( 5 );
      QuantityDenominator           : abap.dec(5);
}
