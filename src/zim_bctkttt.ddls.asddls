@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Báo cáo tồn kho theo thuộc tính'
define root view entity ZIM_BCTKTTT
  as select distinct from I_MaterialStock as MSKA
  //  left outer join ZIM_C_SUM_MASTOCK             as _UU     on  _UU.Material                  = MSKA.Material
  //                                                                 and _UU.Plant                     = MSKA.Plant
  //                                                                 and _UU.StorageLocation           = MSKA.StorageLocation
  //                                                                 and _UU.Batch                     = MSKA.Batch
  //                                                                 and _UU.InventorySpecialStockType = MSKA.InventorySpecialStockType
  //                                                                 and _UU.SpecialStockNumber        = SpecialStockNumber
  //                                                                 and _UU.InventoryStockType        = '01'
  association [0..1] to I_Product                     as MARA         on  MARA.Product = MSKA.Material
  association [0..1] to I_Plant                       as T001W        on  T001W.Plant = MSKA.Plant
  association [0..1] to I_StorageLocation             as t001l        on  t001l.StorageLocation = MSKA.StorageLocation
                                                                      and t001l.Plant           = MSKA.Plant
  association [0..1] to I_ProductStorageLocationBasic as mard         on  mard.Plant           = MSKA.Plant
                                                                      and mard.Product         = MSKA.Material
                                                                      and mard.StorageLocation = MSKA.StorageLocation
  association [0..1] to I_Supplier                    as lfa1         on  lfa1.Supplier = MSKA.Supplier
  association [0..1] to ZCORE_I_PROFILE_CUSTOMER      as profile_cus  on  profile_cus.Customer = MSKA.Customer
  association [0..1] to ZCORE_I_PROFILE_SUPPLIER      as Supplier_cus on  Supplier_cus.Supplier = MSKA.Supplier
  association [0..1] to ZIM_C_CLFOCVDEX               as _NNK         on  _NNK.Matnr          = MSKA.Material
                                                                      and _NNK.Batch          = MSKA.Batch
                                                                      and _NNK.Characteristic = 'Z_GRD'
  association [0..1] to ZIM_C_CLFOCVDEX               as _NSX         on  _NSX.Matnr          = MSKA.Material
                                                                      and _NSX.Batch          = MSKA.Batch
                                                                      and _NSX.Characteristic = 'Z_NSX'
  association [0..1] to ZIM_C_CLFOCVDEX               as _HSD         on  _HSD.Matnr          = MSKA.Material
                                                                      and _HSD.Batch          = MSKA.Batch
                                                                      and _HSD.Characteristic = 'Z_HSD'
  association [0..1] to ZIM_C_CLFOCVDEX               as _DSX         on  _DSX.Matnr          = MSKA.Material
                                                                      and _DSX.Batch          = MSKA.Batch
                                                                      and _DSX.Characteristic = 'Z_DSX'
  association [0..1] to ZIM_C_CLFOCVDEX               as _NCC         on  _NCC.Matnr          = MSKA.Material
                                                                      and _NCC.Batch          = MSKA.Batch
                                                                      and _NCC.Characteristic = 'Z_NCC'
  association [0..1] to ZIM_C_CLFOCVDEX               as _GHICHU      on  _GHICHU.Matnr          = MSKA.Material
                                                                      and _GHICHU.Batch          = MSKA.Batch
                                                                      and _GHICHU.Characteristic = 'Z_GHICHU'
  association [0..1] to ZIM_C_CLFOCVDEX               as _SHD         on  _SHD.Matnr          = MSKA.Material
                                                                      and _SHD.Batch          = MSKA.Batch
                                                                      and _SHD.Characteristic = 'Z_SHD'
  association [0..1] to ZIM_C_CLFOCVDEX               as _SOLOT       on  _SOLOT.Matnr          = MSKA.Material
                                                                      and _SOLOT.Batch          = MSKA.Batch
                                                                      and _SOLOT.Characteristic = 'Z_LOT'
  association [0..1] to ZIM_C_CLFOCVDEX               as _CSX         on  _CSX.Matnr          = MSKA.Material
                                                                      and _CSX.Batch          = MSKA.Batch
                                                                      and _CSX.Characteristic = 'Z_CSX'
  association [0..1] to ZIM_C_CLFOCVDEX               as _HSQD        on  _HSQD.Matnr          = MSKA.Material
                                                                      and _HSQD.Batch          = MSKA.Batch
                                                                      and _HSQD.Characteristic = 'Z_HSQD'
  association [0..1] to ZIM_C_CLFOCVDEX               as _VUN         on  _VUN.Matnr          = MSKA.Material
                                                                      and _VUN.Batch          = MSKA.Batch
                                                                      and _VUN.Characteristic = 'Z_VUN'


{
  key    MSKA.Material, //3
  key    MSKA.Plant, //1
  key    MSKA.StorageLocation, //2
  key    MSKA.Batch, //6
  key    MSKA.InventorySpecialStockType, //9
         /////Special Stock Number
  key    case when MSKA.InventorySpecialStockType = 'E' or MSKA.InventorySpecialStockType = 'T'
           then concat_with_space( ltrim(MSKA.SDDocument,'0'),  concat_with_space( '/' ,ltrim(MSKA.SDDocumentItem,'0'),1),1)
           when MSKA.InventorySpecialStockType = 'K' or MSKA.InventorySpecialStockType = 'M' or MSKA.InventorySpecialStockType = 'O'
           then  ltrim(MSKA.Supplier,'0')
           when MSKA.InventorySpecialStockType = 'Q'
           then   MSKA.WBSElementInternalID
           when MSKA.InventorySpecialStockType = 'V' or MSKA.InventorySpecialStockType = 'W'
           then ltrim(MSKA.Customer,'0')
           else ' '                                                                 end as SpecialStockNumber,
         MARA._Text[1:Language = 'E'].ProductName                                       as ProductName,
         MARA.ProductType, //4
         MARA.ProductGroup, //5
         MARA._ProductTypeName_2[1:Language = 'E'].ProductTypeName                      as ProductTypeName,
         MARA._ProductGroupText_2[1:Language = 'E'].ProductGroupName                    as ProductGroupName,
         MARA.YY1_Chungnhan_PRD,
         case when MARA.YY1_Chungnhan_PRD = '0' then 'AN TOÀN, SẠCH (HÀNG BÌNH THƯỜNG)'
              when MARA.YY1_Chungnhan_PRD = '1' then 'ĐẠT'
              else                                   'KHÔNG ĐẠT' end                    as YY1_ChungnhanDes_PRD,
         MARA.YY1_Dongsanpham_PRD,
         MARA.YY1_GiaviPhugia_PRD,
         MARA.YY1_KichcoHinhdangSize_PRD,
         MARA.YY1_Loaihinhsanxuat_PRD,
         MARA.YY1_LoaiTPthuhoi_PRD,
         MARA.YY1_Quycachdonggoi_PRD,
         MSKA.SDDocument, //10
         MSKA.SDDocumentItem,
         MSKA.Customer, //11
         profile_cus.CustomerFullName                                                   as CustomerName, //28
         MSKA.Supplier, //25 Vendor
         Supplier_cus.SupplierFullName                                                  as SupplierName, //26
         T001W.PlantName, // 2
         t001l.StorageLocationName,

         MSKA.MaterialBaseUnit,
         //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
         //      _UU.Quantity                                                                      as Unrestricted,
         _NNK.CharcFromDate                                                             as NgayNhapKho,
         _NSX.CharcFromDate                                                             as NgaySanXuat,
         _HSD.CharcFromDate                                                             as HanSuDung,
         _DSX.CharcValue                                                                as DonViSanXuat,
         _NCC.CharcValue                                                                as NhaCungCap,
         _GHICHU.CharcValue                                                             as GhiChu,
         _SHD.CharcValue                                                                as SoHopDong,
         _CSX.CharcValue                                                                as CaSanXuat,
         _HSQD.Z_HSQD                                                                   as HSQD,
         _SOLOT.CharcValue                                                              as SoLot,
         _VUN.CharcValue                                                                as ZVun
}
