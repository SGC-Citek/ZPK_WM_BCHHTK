CLASS zcl_im_bctkttt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: gc_comm_scenario TYPE if_com_management=>ty_cscn_id          VALUE 'ZCORE_CS_SAP',
               gc_service_id    TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'Z_API_SAP_REST'.
    "Range of
    DATA: p_otp_dis                    TYPE c LENGTH 2,
          gr_werks                     TYPE RANGE OF werks_d,
          gr_batch                     TYPE RANGE OF zim_bctkttt_main-batch,
          gr_matnr                     TYPE RANGE OF matnr,
          gr_lgort                     TYPE RANGE OF lgort_d_edi_ext,
          gr_prtype                    TYPE RANGE OF zim_bctkttt_main-producttype,
          gr_prdgroup                  TYPE RANGE OF zim_bctkttt_main-productgroup,
          gr_spstock                   TYPE RANGE OF zim_bctkttt_main-inventoryspecialstocktype,
          gr_vblen                     TYPE RANGE OF zde_vbeln,
          gr_kunnr                     TYPE RANGE OF zde_kunnr,
          gr_lgnum                     TYPE RANGE OF zim_bctkttt_main-ewmwarehouse,
          gr_lgtyp                     TYPE RANGE OF zim_bctkttt_main-ewmstoragetype,
          gr_lgpla                     TYPE RANGE OF zim_bctkttt_main-ewmstoragebin,
          gr_sd2                       TYPE RANGE OF zim_bctkttt_main-stockdocumentnumber,
          gr_storagegroup              TYPE RANGE OF  zde_lgber_lgst,
          gr_ewmstocktype              TYPE RANGE OF zim_bctkttt_main-ewmstocktype,
          gr_yy1_vhccontractnumber_sdh TYPE RANGE OF zim_bctkttt_main-yy1_vhccontractnumber_sdh,
          gr_nhacungcap                TYPE RANGE OF zim_bctkttt_main-nhacungcap,
          gr_lotnumber                 TYPE RANGE OF zim_c_clfocvdex-charcvalue,
          gr_vun                       TYPE RANGE OF zim_c_clfocvdex-charcvalue,
          gr_nnk                       TYPE RANGE OF cl_abap_context_info=>ty_system_date,
          gr_nsx                       TYPE RANGE OF cl_abap_context_info=>ty_system_date,
          gr_hsd                       TYPE RANGE OF cl_abap_context_info=>ty_system_date,
          gr_ncc                       TYPE RANGE OF zim_c_clfocvdex-charcvalue,
          gr_dsx                       TYPE RANGE OF zim_c_clfocvdex-charcvalue,
          gr_clcq                      TYPE RANGE OF zim_c_clfocvdex-charcvalue,
          gr_ctdl                      TYPE RANGE OF zim_c_clfocvdex-charcvalue,
          gr_mtx                       TYPE RANGE OF zim_c_clfocvdex-charcvalue,
          gr_palletno                  TYPE RANGE OF zim_bctkttt_main-palletno,
          gr_handlingunitnumber        TYPE RANGE OF zim_bctkttt_main-handlingunitnumber,
          gr_ngaynhapkho               TYPE RANGE OF zim_bctkttt_main-ngaynhapkho,
          gw_ngaycanhbao               TYPE datum,
          p_ngaycanhbao                TYPE int4.


    DATA: gv_sort_string     TYPE string,
          gv_sort_tmp        TYPE string,
          table_sort         TYPE abap_sortorder_tab,
          gt_fields          TYPE if_rap_query_request=>tt_requested_elements,
          gt_aggregation     TYPE if_rap_query_request=>tt_requested_elements,
          gv_top             TYPE int8,
          gv_skip            TYPE int8,
          gv_max_rows        TYPE int8,
          gt_aggr_element    TYPE if_rap_query_aggregation=>tt_aggregation_elements,
          gt_grouped_element TYPE   if_rap_query_aggregation=>tt_grouped_elements.
    DATA: gt_data          TYPE TABLE OF zim_bctkttt_main,
          gt_data_alv      TYPE TABLE OF zim_bctkttt_main,
          gt_data_sort_alv TYPE TABLE OF zim_bctkttt_main,
          gs_data          LIKE LINE OF gt_data.

    METHODS handle_sort   IMPORTING io_request  TYPE REF TO if_rap_query_request.
    METHODS handle_filter IMPORTING io_request  TYPE REF TO if_rap_query_request.
    METHODS set_page IMPORTING io_request  TYPE REF TO if_rap_query_request.

    METHODS get_data.
    METHODS get_tkkvt.
    METHODS get_tkvt.
    METHODS get_stocktype  RETURNING VALUE(lt_response) TYPE zscm_stocktype=>tyt_yy_1_ewm_stock_type_type.
ENDCLASS.



CLASS ZCL_IM_BCTKTTT IMPLEMENTATION.


  METHOD get_data.

    IF p_otp_dis EQ '1'. "Xem Tồn kho quản lý vị trí
      get_tkkvt(  ).  "
      IF lines( gt_aggregation ) = 2.
        gv_sort_string = 'BASEUNIT'.
      ELSEIF lines( gt_aggregation ) = 1.
        READ TABLE gt_aggregation INTO DATA(ls_aggregation) INDEX 1.
        IF sy-subrc = 0.
          gv_sort_string = |{ ls_aggregation }|.
        ENDIF.
      ENDIF.
    ELSEIF  p_otp_dis EQ '0'.
      get_tkvt(  ).         "Xem Tồn kho không vị trí
      IF lines( gt_aggregation ) = 2.
        gv_sort_string = 'BASEUNIT'.
      ELSEIF lines( gt_aggregation ) = 1.
        READ TABLE gt_aggregation INTO ls_aggregation INDEX 1.
        IF sy-subrc = 0.
          gv_sort_string = |{ ls_aggregation }|.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_stocktype.
    DATA: lo_http_client    TYPE REF TO if_web_http_client,
          lo_client_proxy   TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_response       TYPE REF TO /iwbep/if_cp_response_read_lst,
          lo_request        TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_filter_factory TYPE REF TO /iwbep/if_cp_filter_factory,
          lr_language       TYPE RANGE OF zscm_stocktype=>tys_yy_1_ewm_stock_type_type-language,
          lr_ewmwarehouse   TYPE RANGE OF zscm_stocktype=>tys_yy_1_ewm_stock_type_type-ewmwarehouse,
          lr_ewmstock_type  TYPE RANGE OF zscm_stocktype=>tys_yy_1_ewm_stock_type_type-ewmstock_type.

    DATA:
      lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_3    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = gc_comm_scenario
                                    service_id    = gc_service_id    ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                              is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                                  proxy_model_id      = 'ZSCM_STOCKTYPE'
                                                                  proxy_model_version = '0001' )
                              io_http_client           = lo_http_client
                              iv_relative_service_root = '/sap/opu/odata/sap/YY1_EWM_STOCKTYPE_CDS/' ).
        ASSERT lo_http_client IS BOUND.

        " Navigate to the resource
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'YY_1_EWM_STOCK_TYPE' )->create_request_for_read( ).
        lo_filter_factory = lo_request->create_filter_factory( ).

        lr_ewmwarehouse  = VALUE #( sign = 'I' option = 'EQ' ( low = '100' ) ).
        lo_filter_node_1 = lo_filter_factory->create_by_range( iv_property_path     = 'EWMWAREHOUSE'
                                                                it_range             = lr_ewmwarehouse ).

        lr_ewmstock_type =  VALUE #( sign = 'I' option = 'EQ' ( low = 'B' ) ).
        lo_filter_node_2 = lo_filter_factory->create_by_range( iv_property_path     = 'EWMSTOCK_TYPE'
                                                                it_range             = lr_ewmstock_type ).

        lr_language      =  VALUE #( sign = 'I' option = 'EQ' ( low = 'EN' ) ).
        lo_filter_node_3 = lo_filter_factory->create_by_range( iv_property_path  = 'LANGUAGE'
                                                                it_range         = lr_language ).

        lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 )->and( lo_filter_node_3 ).



*        LO_REQUEST->SET_FILTER( LO_FILTER_NODE_ROOT ).
        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_response ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_provider_error).
        " Handle provider_error
      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.
    ENDTRY.

  ENDMETHOD.


  METHOD get_tkkvt.
    SELECT zmain~*,
           i_uom~unitofmeasure_e AS materialbaseunit,
           cn~description        AS chungnhan,
           dsp~description   AS dongsanpham,
           gvpg~description  AS giaviphugia,
           size~description  AS kichcohinhdangsize,
           lhsp~description  AS loaihinhsanxuat,
           ltpth~description AS loaitpthuhoi,
           qcdg~description  AS quycachdonggoi,
           zsum~quantity  AS unrestricted,
           zsum1~quantity AS blocked     ,
           zsum4~quantity AS transitandtranfer ,
           zsum3~quantity AS returns ,
           zsum2~quantity AS qualityinspection,
           i_sotp~yy1_vhccontractnumber_sdh,
           _hsd~z_hsqd AS hsqd,
           _clcq~charcvalue   AS chatluongcamquan,
           _ctdl~charcvalue   AS chitieudinhluong,
           _cvt~charcvalue    AS vitri,
           _husap~charcvalue  AS husap,
           _mtx~charcvalue    AS matruyxuat,
           _ngsp~charcvalue   AS nguongocsanpham,
           marm~quantitynumerator,
           marm~quantitydenominator,
           marm~alternativeunit AS baseunit,
           _soldtoparty~customername1        AS soldtopartyname,
           _namencc~businesspartnername1     AS namenhacungcap,
           @p_otp_dis AS p_otp_dis
      FROM zim_bctkttt AS zmain
    LEFT JOIN i_salesordertp AS i_sotp
                             ON ltrim( i_sotp~salesorder ,'0' ) = ltrim( zmain~sddocument ,'0' )
    LEFT JOIN i_productunitsofmeasure AS marm
                                      ON marm~product         = zmain~material
                                     AND marm~alternativeunit = 'Z1'
    LEFT JOIN i_salesdocumentpartner AS vbpa
                                     ON ltrim( vbpa~salesdocument ,'0' ) = ltrim( zmain~sddocument ,'0' )
                                    AND vbpa~partnerfunction     = 'AG'
    LEFT JOIN zcore_i_profile_customer AS _soldtoparty ON _soldtoparty~customer        = vbpa~customer

    LEFT JOIN zim_c_sum_mastock AS zsum
                                ON zsum~material                  = zmain~material
                               AND zsum~plant                     = zmain~plant
                               AND zsum~storagelocation           = zmain~storagelocation
                               AND zsum~batch                     = zmain~batch
                               AND zsum~inventoryspecialstocktype = zmain~inventoryspecialstocktype
                               AND zsum~specialstocknumber        = zmain~specialstocknumber
                               AND zsum~inventorystocktype        = '01'
    LEFT JOIN zim_c_sum_mastock AS zsum1
                                ON zsum1~material                  = zmain~material
                               AND zsum1~plant                     = zmain~plant
                               AND zsum1~storagelocation           = zmain~storagelocation
                               AND zsum1~batch                     = zmain~batch
                               AND zsum1~inventoryspecialstocktype = zmain~inventoryspecialstocktype
                               AND zsum1~specialstocknumber        = zmain~specialstocknumber
                               AND zsum1~inventorystocktype        = '07'
    LEFT JOIN zim_c_sum_mastock AS zsum3
                                ON zsum3~material                  = zmain~material
                               AND zsum3~plant                     = zmain~plant
                               AND zsum3~storagelocation           = zmain~storagelocation
                               AND zsum3~batch                     = zmain~batch
                               AND zsum3~inventoryspecialstocktype = zmain~inventoryspecialstocktype
                               AND zsum3~specialstocknumber        = zmain~specialstocknumber
                               AND zsum3~inventorystocktype        = '03'
    LEFT JOIN zim_c_sum_mastock AS zsum2
                                ON zsum2~material                  = zmain~material
                               AND zsum2~plant                     = zmain~plant
                               AND zsum2~storagelocation           = zmain~storagelocation
                               AND zsum2~batch                     = zmain~batch
                               AND zsum2~inventoryspecialstocktype = zmain~inventoryspecialstocktype
                               AND zsum2~specialstocknumber        = zmain~specialstocknumber
                               AND zsum2~inventorystocktype        = '02'
    LEFT JOIN zim_c_sum_mastock2 AS zsum4
                                ON zsum4~material                  = zmain~material
                               AND zsum4~plant                     = zmain~plant
                               AND zsum4~storagelocation           = zmain~storagelocation
                               AND zsum4~batch                     = zmain~batch
                               AND zsum4~inventoryspecialstocktype = zmain~inventoryspecialstocktype
                               AND zsum4~specialstocknumber        = zmain~specialstocknumber
    LEFT JOIN i_unitofmeasure AS i_uom
                              ON i_uom~unitofmeasure = zmain~materialbaseunit
    LEFT JOIN i_customfieldcodelisttext AS cn
                                        ON cn~customfieldid = 'YY1_CHUNGNHAN'
                                       AND cn~code          = zmain~yy1_chungnhan_prd
    LEFT JOIN i_customfieldcodelisttext AS dsp
                                        ON dsp~customfieldid = 'YY1_DONGSANPHAM'
                                       AND dsp~code          = zmain~yy1_dongsanpham_prd
    LEFT JOIN zcore_i_profile_supplier AS _namencc
                                       ON ltrim( _namencc~supplier ,'0' ) = ltrim( zmain~nhacungcap ,'0' )
    LEFT JOIN i_customfieldcodelisttext AS gvpg
                             ON gvpg~customfieldid = 'YY1_GIAVIPHUGIA'
                            AND gvpg~code          = zmain~yy1_giaviphugia_prd
    LEFT JOIN i_customfieldcodelisttext AS size
                             ON size~customfieldid  = 'YY1_KICHCOHINHDANGSIZE'
                            AND size~code           = zmain~yy1_kichcohinhdangsize_prd
    LEFT JOIN i_customfieldcodelisttext AS lhsp
                             ON lhsp~customfieldid = 'YY1_LOAIHINHSANXUAT'
                            AND lhsp~code          = zmain~yy1_loaihinhsanxuat_prd
    LEFT JOIN i_customfieldcodelisttext AS ltpth
                             ON ltpth~customfieldid  = 'YY1_LOAITPTHUHOI'
                            AND ltpth~code           = zmain~yy1_loaitpthuhoi_prd
    LEFT JOIN i_customfieldcodelisttext AS qcdg
                             ON qcdg~customfieldid = 'YY1_QUYCACHDONGGOI'
                            AND qcdg~code          = zmain~yy1_quycachdonggoi_prd
    LEFT JOIN zim_c_clfocvdex  AS _hsd  ON  _hsd~matnr          = zmain~material
                                        AND _hsd~batch          = zmain~batch
                                        AND _hsd~characteristic = 'Z_HSQD'
    LEFT JOIN zim_c_clfocvdex  AS _clcq  ON  _clcq~matnr          = zmain~material
                                         AND _clcq~batch          = zmain~batch
                                         AND _clcq~characteristic = 'Z_CLCQ'
    LEFT JOIN zim_c_clfocvdex  AS _ctdl  ON  _ctdl~matnr          = zmain~material
                                         AND _ctdl~batch          = zmain~batch
                                         AND _ctdl~characteristic = 'Z_CTDL'
    LEFT JOIN zim_c_clfocvdex  AS _cvt  ON _cvt~matnr          = zmain~material
                                       AND _cvt~batch          = zmain~batch
                                       AND _cvt~characteristic = 'Z_VTGC'
    LEFT JOIN zim_c_clfocvdex  AS _husap  ON _husap~matnr          = zmain~material
                                         AND _husap~batch          = zmain~batch
                                         AND _husap~characteristic = 'Z_HU'
    LEFT JOIN zim_c_clfocvdex  AS _mtx   ON _mtx~matnr          = zmain~material
                                        AND _mtx~batch          = zmain~batch
                                        AND _mtx~characteristic = 'Z_MTX'
    LEFT JOIN zim_c_clfocvdex  AS _ngsp  ON _ngsp~matnr          = zmain~material
                                        AND _ngsp~batch          = zmain~batch
                                        AND _ngsp~characteristic = 'Z_NGSP'
    WHERE zmain~plant                      IN @gr_werks
      AND zmain~storagelocation            IN @gr_lgort
      AND zmain~material                   IN @gr_matnr
      AND zmain~producttype                IN @gr_prtype
      AND zmain~productgroup               IN @gr_prdgroup
      AND zmain~batch                      IN @gr_batch
      AND zmain~inventoryspecialstocktype  IN @gr_spstock
      AND zmain~sddocument                 IN @gr_vblen
      AND zmain~customer                   IN @gr_kunnr
      AND i_sotp~yy1_vhccontractnumber_sdh IN @gr_yy1_vhccontractnumber_sdh
      AND zmain~nhacungcap                 IN @gr_nhacungcap
      AND zmain~solot                      IN @gr_lotnumber
      AND zmain~zvun                       IN @gr_vun
      AND _mtx~charcvalue                  IN @gr_mtx
      AND zmain~ngaynhapkho                IN @gr_ngaynhapkho
    INTO CORRESPONDING FIELDS OF TABLE @gt_data.
  ENDMETHOD.


  METHOD get_tkvt.

    DATA(lt_stocktype) = get_stocktype(  ).

    SELECT i_psp~parenthandlingunituuid,
           i_psp~stockitemuuid,
           i_psp~ewmwarehouse,
           i_psp~ewmstoragetype,
           i_psp~ewmstoragebin,
           i_psp~ewmstocktype,
           sttypetext~ewmstock_type_name AS ewmstocktypename,
           i_psp~product AS material,
           makt~productname,
           mara~producttype,
           t134t~producttypename,
           mara~productgroup,
           t023t~productgroupname,
           i_psp~batch,
           i_psp~ewmstockowner,
           i_psp~entitledtodisposeparty,
           i_psp~stockdocumentcategory,
           i_psp~stockdocumentnumber,
           i_psp~stockitemnumber,
           i_psp~ewmstockreferencedoccategory,
           i_psp~ewmstockreferencedocument,
           i_psp~ewmstockreferencedocumentitem,
           i_psp~ewmloadingornetweight,
           i_psp~ewmloadingornetvolume,
           i_uom~unitofmeasure_e AS ewmloadingornetvolumeunit,
           i_uom2~unitofmeasure_e AS ewmloadingornetweightunit,
           i_psp~handlingunitnumber,
           i_psp~ewmgoodsreceiptdatetime,
           i_psp~shelflifeexpirationdate,
           i_uom3~unitofmeasure_e AS ewmstockquantitybaseunit,
           i_psp~ewmstorbinisblockedforputaway,
           i_psp~ewmstorbinisblockedforremoval,
           i_psp~ewmstockquantityinbaseunit,
           aqua~availableewmstockqty,
           _nnk~charcfromdate                         AS ngaynhapkho,
            _nsx~charcfromdate                        AS ngaysanxuat,
            _hsd~charcfromdate                        AS hansudung,
            _dsx~charcvalue                           AS donvisanxuat,
            _ncc~charcvalue                           AS nhacungcap,
            _namencc~businesspartnername1             AS namenhacungcap,
            _ghichu~charcvalue                        AS ghichu,
            _shd~charcvalue                           AS sohopdong,
            _csx~charcvalue                           AS casanxuat,
            _hsqd~z_hsqd                              AS hsqd,
            _solot~charcvalue                         AS solot,
            _clcq~charcvalue                          AS chatluongcamquan,
            _ctdl~charcvalue                          AS chitieudinhluong,
            _vun~charcvalue                           AS zvun,
            _mtx~charcvalue                           AS matruyxuat,
            _cvt~charcvalue                           AS vitri,
            cn~description   AS chungnhan,
           dsp~description   AS dongsanpham,
           gvpg~description  AS giaviphugia,
           size~description  AS kichcohinhdangsize,
           lhsp~description  AS loaihinhsanxuat,
           ltpth~description AS loaitpthuhoi,
           qcdg~description  AS quycachdonggoi,
           i_sotp~yy1_vhccontractnumber_sdh,
           ztb_kb_day~lgber_lgst  AS ewmstoragegroup,
           CASE WHEN ztb_wm_hu~palletno IS NOT INITIAL
                THEN ztb_wm_hu~palletno
                ELSE ztb_wm_bchudk~palletno END AS palletno,
           ztb_wm_hu~note                       AS ghichuhu,
           marm~quantitynumerator,
           marm~quantitydenominator,
           marm~alternativeunit AS baseunit,
           _soldtoparty~customername1 AS soldtopartyname

    FROM i_ewm_physstockprod  AS i_psp
    LEFT JOIN zsdk2d_tb_lgpla AS ztb_kb_lgpla
                               ON ztb_kb_lgpla~lgnum = i_psp~ewmwarehouse
                              AND ztb_kb_lgpla~lgpla = i_psp~ewmstoragebin
    LEFT  JOIN zsdk2d_tb_lgnum AS ztb_kb_day
                               ON ztb_kb_day~lgnum   = ztb_kb_lgpla~lgnum
                              AND ztb_kb_day~ten_day = ztb_kb_lgpla~ten_day
    LEFT JOIN ztb_wm_hu     ON ztb_wm_hu~handlingunitnumber = i_psp~handlingunitnumber
    LEFT JOIN ztb_wm_bchudk ON ztb_wm_bchudk~handling_unit  = i_psp~handlingunitnumber
    LEFT JOIN i_productunitsofmeasure AS marm
                                      ON marm~product         = i_psp~product
                                     AND marm~alternativeunit = 'Z1'
    LEFT JOIN i_salesdocumentpartner AS vbpa
                                     ON ltrim( vbpa~salesdocument ,'0' ) = ltrim( i_psp~stockdocumentnumber ,'0' )
                                    AND vbpa~partnerfunction     = 'AG'
    LEFT JOIN zcore_i_profile_customer AS _soldtoparty ON _soldtoparty~customer = vbpa~customer

    LEFT JOIN i_salesordertp AS i_sotp
                             ON ltrim( i_sotp~salesorder ,'0' ) = ltrim( i_psp~stockdocumentnumber ,'0' )
    LEFT JOIN i_product     AS mara
                            ON mara~product = i_psp~product
    LEFT JOIN i_producttext AS makt
                            ON makt~product  = i_psp~product
                           AND makt~language = 'E'
    LEFT JOIN i_unitofmeasure AS i_uom
                              ON i_uom~unitofmeasure = i_psp~ewmloadingornetweightunit
    LEFT JOIN i_unitofmeasure AS i_uom2
                              ON i_uom2~unitofmeasure = i_psp~ewmloadingornetvolumeunit
    LEFT JOIN i_unitofmeasure AS i_uom3
                              ON i_uom3~unitofmeasure = i_psp~ewmstockquantitybaseunit
    LEFT JOIN i_producttypetext_2 AS t134t
                                  ON t134t~producttype = mara~producttype
                                 AND t134t~language    = 'E'
    LEFT JOIN i_productgrouptext_2 AS t023t
                                   ON t023t~productgroup = mara~productgroup
                                  AND t023t~language     = 'E'
    LEFT JOIN i_ewm_availablestock AS aqua
                                   ON aqua~parenthandlingunituuid = i_psp~parenthandlingunituuid
                                  AND aqua~stockitemuuid          = i_psp~stockitemuuid
     LEFT JOIN zim_c_clfocvdex  AS _clcq  ON  _clcq~matnr          = i_psp~product
                                          AND _clcq~batch          = i_psp~batch
                                          AND _clcq~characteristic = 'Z_CLCQ'
    LEFT JOIN zim_c_clfocvdex  AS _ctdl  ON  _ctdl~matnr          = i_psp~product
                                         AND _ctdl~batch          = i_psp~batch
                                         AND _ctdl~characteristic = 'Z_CTDL'
    LEFT JOIN zim_c_clfocvdex  AS _nnk  ON  _nnk~matnr          = i_psp~product
                                        AND _nnk~batch          = i_psp~batch
                                        AND _nnk~characteristic = 'Z_GRD'
    LEFT JOIN zim_c_clfocvdex  AS _nsx  ON  _nsx~matnr          = i_psp~product
                                        AND _nsx~batch          = i_psp~batch
                                        AND _nsx~characteristic = 'Z_NSX'
    LEFT JOIN zim_c_clfocvdex  AS _hsd  ON  _hsd~matnr          = i_psp~product
                                        AND _hsd~batch          = i_psp~batch
                                        AND _hsd~characteristic = 'Z_HSD'
    LEFT JOIN zim_c_clfocvdex  AS _dsx  ON  _dsx~matnr          = i_psp~product
                                        AND _dsx~batch          = i_psp~batch
                                        AND _dsx~characteristic = 'Z_DSX'
    LEFT JOIN zim_c_clfocvdex  AS _ncc  ON  _ncc~matnr          = i_psp~product
                                        AND _ncc~batch          = i_psp~batch
                                        AND _ncc~characteristic = 'Z_NCC'
    LEFT JOIN zcore_i_profile_supplier AS _namencc
                                       ON ltrim( _namencc~supplier ,'0' ) = ltrim( _ncc~charcvalue ,'0' )
    LEFT JOIN zim_c_clfocvdex  AS _vun   ON  _vun~matnr         = i_psp~product
                                        AND _vun~batch          = i_psp~batch
                                        AND _vun~characteristic = 'Z_VUN'
    LEFT JOIN zim_c_clfocvdex  AS _mtx   ON _mtx~matnr          = i_psp~product
                                        AND _mtx~batch          = i_psp~batch
                                        AND _mtx~characteristic = 'Z_MTX'
    LEFT JOIN zim_c_clfocvdex  AS _ghichu  ON  _ghichu~matnr          = i_psp~product
                                           AND _ghichu~batch          = i_psp~batch
                                           AND _ghichu~characteristic = 'Z_GHICHU'
    LEFT JOIN zim_c_clfocvdex  AS _shd  ON  _shd~matnr          = i_psp~product
                                        AND _shd~batch          = i_psp~batch
                                        AND _shd~characteristic = 'Z_SHD'
    LEFT JOIN zim_c_clfocvdex  AS _solot  ON  _solot~matnr          = i_psp~product
                                        AND _solot~batch            = i_psp~batch
                                        AND _solot~characteristic   = 'Z_LOT'
    LEFT JOIN zim_c_clfocvdex  AS _csx  ON  _csx~matnr          = i_psp~product
                                        AND _csx~batch          = i_psp~batch
                                        AND _csx~characteristic = 'Z_CSX'
    LEFT JOIN zim_c_clfocvdex  AS _hsqd  ON  _hsqd~matnr          = i_psp~product
                                         AND _hsqd~batch          = i_psp~batch
                                         AND _hsqd~characteristic = 'Z_HSQD'
    LEFT JOIN zim_c_clfocvdex  AS _cvt  ON _cvt~matnr          = i_psp~product
                                       AND _cvt~batch          = i_psp~batch
                                       AND _cvt~characteristic = 'Z_VTGC'
    LEFT JOIN @lt_stocktype AS sttypetext
                            ON sttypetext~ewmwarehouse  = i_psp~ewmwarehouse
                           AND sttypetext~ewmstock_type = i_psp~ewmstocktype
                           AND sttypetext~language      = 'EN'
  LEFT JOIN i_customfieldcodelisttext AS cn
                                        ON cn~customfieldid = 'YY1_CHUNGNHAN'
                                       AND cn~code          = mara~yy1_chungnhan_prd
    LEFT JOIN i_customfieldcodelisttext AS dsp
                                        ON dsp~customfieldid = 'YY1_DONGSANPHAM'
                                       AND dsp~code          = mara~yy1_dongsanpham_prd
    LEFT JOIN i_customfieldcodelisttext AS gvpg
                             ON gvpg~customfieldid = 'YY1_GIAVIPHUGIA'
                            AND gvpg~code          = mara~yy1_giaviphugia_prd
    LEFT JOIN i_customfieldcodelisttext AS size
                             ON size~customfieldid  = 'YY1_KICHCOHINHDANGSIZE'
                            AND size~code           = mara~yy1_kichcohinhdangsize_prd
    LEFT JOIN i_customfieldcodelisttext AS lhsp
                             ON lhsp~customfieldid = 'YY1_LOAIHINHSANXUAT'
                            AND lhsp~code          = mara~yy1_loaihinhsanxuat_prd
    LEFT JOIN i_customfieldcodelisttext AS ltpth
                             ON ltpth~customfieldid  = 'YY1_LOAITPTHUHOI'
                            AND ltpth~code           = mara~yy1_loaitpthuhoi_prd
    LEFT JOIN i_customfieldcodelisttext AS qcdg
                             ON qcdg~customfieldid = 'YY1_QUYCACHDONGGOI'
                            AND qcdg~code          = mara~yy1_quycachdonggoi_prd
    WHERE i_psp~ewmwarehouse                 IN @gr_lgnum
      AND i_psp~ewmstoragetype               IN @gr_lgtyp
      AND i_psp~ewmstoragebin                IN @gr_lgpla				
      AND i_psp~product      		         IN @gr_matnr
      AND mara~productgroup  				 IN @gr_prdgroup
      AND mara~producttype   				 IN @gr_prtype
      AND i_psp~batch        				 IN @gr_batch
      AND i_psp~stockdocumentnumber          IN @gr_sd2
      AND i_psp~ewmstocktype                 IN @gr_ewmstocktype
      AND ztb_kb_day~lgber_lgst              IN @gr_storagegroup
      AND i_sotp~yy1_vhccontractnumber_sdh   IN @gr_yy1_vhccontractnumber_sdh
      AND _ncc~charcvalue                    IN @gr_nhacungcap
      AND _solot~charcvalue                  IN @gr_lotnumber
      AND _vun~charcvalue                    IN @gr_vun
      AND _mtx~charcvalue                    IN @gr_mtx
      AND i_psp~handlingunitnumber           IN @gr_handlingunitnumber
      AND _nnk~charcfromdate                 IN @gr_ngaynhapkho
      AND ( ztb_wm_hu~palletno               IN @gr_palletno
       OR  ztb_wm_bchudk~palletno            IN @gr_palletno )
    INTO CORRESPONDING FIELDS OF TABLE @gt_data.
  ENDMETHOD.


  METHOD handle_filter.
    TRY.
        "get and add filter
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).

        LOOP AT lt_filter_cond REFERENCE INTO DATA(ls_filter_cond).
          CASE ls_filter_cond->name.
            WHEN 'NGAYCANHBAO'.
              READ TABLE ls_filter_cond->range[] INDEX 1 INTO DATA(ls_range).
              IF sy-subrc = 0.
                gw_ngaycanhbao = ls_range-low + cl_abap_context_info=>get_system_date(  ).
                p_ngaycanhbao  = ls_range-low.
              ENDIF.
            WHEN 'P_OTP_DIS'.
              READ TABLE ls_filter_cond->range[] INDEX 1 INTO ls_range.
              IF sy-subrc = 0.
                p_otp_dis = ls_range-low.
              ENDIF.
            WHEN 'PLANT'.
              gr_werks =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'BATCH'.
              gr_batch =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'MATERIAL'.
              gr_matnr =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'STORAGELOCATION'.
              gr_lgort =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'PRODUCTTYPE'.
              gr_prtype =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'PRODUCTGROUP'.
              gr_prdgroup =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'INVENTORYSPECIALSTOCKTYPE'.
              gr_spstock =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'SDDOCUMENT'.
              gr_vblen =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'CUSTOMER'.
              gr_kunnr =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'STOCKDOCUMENTNUMBER'.
              gr_sd2 =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'EWMWAREHOUSE'.
              gr_lgnum =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'EWMSTORAGETYPE'.
              gr_lgtyp =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'EWMSTORAGEBIN'.
              gr_lgpla =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'EWMSTORAGEGROUP'.
              gr_storagegroup =  CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'EWMSTOCKTYPE'.
              gr_ewmstocktype = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'YY1_VHCCONTRACTNUMBER_SDH'.
              gr_yy1_vhccontractnumber_sdh = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'NHACUNGCAP'.
              gr_nhacungcap = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'ZVUN'.
              gr_vun = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'SOLOT'.
              gr_lotnumber = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'MATRUYXUAT'.
              gr_mtx = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'PALLETNO'.
              gr_palletno = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'HANDLINGUNITNUMBER'.
              gr_handlingunitnumber = CORRESPONDING #( ls_filter_cond->range[] ).
            WHEN 'NGAYNHAPKHO'.
              gr_ngaynhapkho = CORRESPONDING #( ls_filter_cond->range[] ).
          ENDCASE.
          CLEAR: ls_range.
        ENDLOOP.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.
  ENDMETHOD.


  METHOD handle_sort.
    DATA: lv_grouping      TYPE string.
    DATA: systemstatus     TYPE string,
          systemstatusoper TYPE string,
          lv_defautl       TYPE char255.

    DATA(lt_sort)          = io_request->get_sort_elements( ).
    DATA(lt_sort_criteria) = VALUE string_table( FOR sort_element IN lt_sort
                                                ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                                            THEN ` descending`
                                                                                   ELSE ` ascending` ) ) ).
    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    lv_grouping = concat_lines_of( table = lt_grouped_element sep = `, ` ).
    IF p_otp_dis EQ '1'.
      gv_sort_string = COND #( WHEN lv_grouping IS NOT INITIAL
                                         THEN lv_grouping
                                         WHEN lt_sort_criteria IS INITIAL
                                         THEN `Plant,Material,StorageLocation,Batch`
                                         ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).
    ELSE.
      gv_sort_string = COND #( WHEN lv_grouping IS NOT INITIAL
                                           THEN lv_grouping
                                           WHEN lt_sort_criteria IS INITIAL
                                           THEN `EWMWarehouse,Material,EWMStorageBin,Batch`
                                           ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).
    ENDIF.

    IF lt_sort_criteria IS INITIAL.
      IF p_otp_dis EQ '1'.
        APPEND VALUE abap_sortorder( name = 'plant' descending  = ' ' astext  = '' ) TO table_sort.
        APPEND VALUE abap_sortorder( name = 'Material' descending  = ' ' astext  = '' ) TO table_sort.
        APPEND VALUE abap_sortorder( name = 'StorageLocation' descending  = ' ' astext  = '' ) TO table_sort.
        APPEND VALUE abap_sortorder( name = 'Batch' descending  = ' ' astext  = '' ) TO table_sort.
      ELSE.
        APPEND VALUE abap_sortorder( name = 'EWMWarehouse' descending  = ' ' astext  = '' ) TO table_sort.
        APPEND VALUE abap_sortorder( name = 'Material' descending  = ' ' astext  = '' ) TO table_sort.
        APPEND VALUE abap_sortorder( name = 'EWMStorageBin' descending  = ' ' astext  = '' ) TO table_sort.
        APPEND VALUE abap_sortorder( name = 'Batch' descending  = ' ' astext  = '' ) TO table_sort.
      ENDIF..
    ELSE.

      table_sort = VALUE abap_sortorder_tab( FOR sort_element2 IN lt_sort (
      name        = sort_element2-element_name
      descending  = sort_element2-descending
      astext      = ''
    ) ).
    ENDIF.

  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    "Xem tồn kho không vị trí
    "p_otp_dis = 1
    "Xem tồn kho vị trí
    "p_otp_dis = 2
    "Filter
    handle_filter( io_request ).
    "Sort
    handle_sort( io_request ).
    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    DATA(lv_grouping) = concat_lines_of( table = lt_grouped_element sep = `, ` ).
    "SET PAGE
    set_page( io_request ).
    "Get Data
    get_data(  ).

    "RESPONSE DATA
    DATA(lv_req_elements) =  concat_lines_of( table = gt_fields sep = `, ` ).

    " get material header text
    DATA(lt_product) = CORRESPONDING zcore_cl_get_long_text=>ty_product(  gt_data DISCARDING DUPLICATES
                                                                          MAPPING product = material ).
    DATA(lt_productbasictext) = zcore_cl_get_long_text=>get_multi_material_basic_text( it_material = lt_product ).

    LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
      READ TABLE lt_productbasictext INTO DATA(ls_productbasictext)
            WITH KEY product = <lfs_data>-material.
      IF sy-subrc = 0 AND ls_productbasictext-long_text IS NOT INITIAL.
        <lfs_data>-materialbasictext = ls_productbasictext-long_text.
      ENDIF.

      IF <lfs_data>-hsqd <> 0.
        <lfs_data>-unrestricteduse = <lfs_data>-unrestricted / <lfs_data>-hsqd.
        <lfs_data>-blockedthu      = <lfs_data>-blocked / <lfs_data>-hsqd.
        <lfs_data>-ewmstockquantityinbaseunitthu = <lfs_data>-ewmstockquantityinbaseunit / <lfs_data>-hsqd.
        <lfs_data>-availableewmstockqtythu       = <lfs_data>-availableewmstockqty / <lfs_data>-hsqd.
      ELSE.
        IF <lfs_data>-baseunit = 'Z1'.
          <lfs_data>-hsqd            = <lfs_data>-quantitynumerator / <lfs_data>-quantitydenominator.
          <lfs_data>-unrestricteduse = <lfs_data>-unrestricted / <lfs_data>-hsqd.
          <lfs_data>-blockedthu      = <lfs_data>-blocked / <lfs_data>-hsqd.
          <lfs_data>-ewmstockquantityinbaseunitthu = <lfs_data>-ewmstockquantityinbaseunit / <lfs_data>-hsqd.
          <lfs_data>-availableewmstockqtythu       = <lfs_data>-availableewmstockqty / <lfs_data>-hsqd.
        ENDIF.
      ENDIF.

      IF <lfs_data>-hansudung IS NOT INITIAL.
        IF gw_ngaycanhbao >= <lfs_data>-hansudung AND <lfs_data>-hansudung >= cl_abap_context_info=>get_system_date(  ).
          <lfs_data>-uuidstatus = '1'.
        ELSEIF <lfs_data>-hansudung <=  cl_abap_context_info=>get_system_date(  ).
          <lfs_data>-uuidstatus = '2'.
        ENDIF.
      ENDIF.
      CASE <lfs_data>-uuidstatus.
        WHEN '1'.
          <lfs_data>-uuidstatuscritical = 1.
          <lfs_data>-uuidstatusname     = 'Sắp hết HSD'.
        WHEN '2'.
          <lfs_data>-uuidstatuscritical = 2.
          <lfs_data>-uuidstatusname     = 'Hết HSD'.
        WHEN OTHERS.
          <lfs_data>-uuidstatuscritical = 0.
      ENDCASE.

      <lfs_data>-baseunit = 'THU'.

      IF p_otp_dis EQ '1'. "Xem tồn kho không vị trí
        IF  ( <lfs_data>-unrestricted  + <lfs_data>-blocked + <lfs_data>-unrestricted + <lfs_data>-transitandtranfer + <lfs_data>-returns ) = 0.
          DELETE gt_data.
        ENDIF.
      ELSE.
        IF  ( <lfs_data>-availableewmstockqty + <lfs_data>-ewmstockquantityinbaseunit ) = 0.
          DELETE gt_data.
        ENDIF.
      ENDIF.

    ENDLOOP.

    DATA: lt_data_tmp LIKE gt_data_alv.
    SELECT (lv_req_elements)
    FROM @gt_data AS data
    GROUP BY (lv_grouping)
    ORDER BY (gv_sort_string)
    INTO CORRESPONDING FIELDS OF TABLE @gt_data_alv.
*    OFFSET @gv_skip UP TO @gv_max_rows ROWS.


    DATA(lv_to)   = gv_skip + gv_max_rows.
    DATA(lv_from) = gv_skip + 1.
*
    SORT gt_data_alv BY (table_sort).

    LOOP AT gt_data_alv INTO DATA(ls_data_alv) FROM lv_from TO lv_to.
      APPEND ls_data_alv TO lt_data_tmp.
    ENDLOOP.

    SORT gt_data     BY (table_sort).

    io_response->set_total_number_of_records( lines( gt_data ) ).
    io_response->set_data( lt_data_tmp ).
  ENDMETHOD.


  METHOD set_page.
    gt_fields        = io_request->get_requested_elements( ).
    gt_aggregation   = io_request->get_requested_elements( ).
    gt_aggr_element  = io_request->get_aggregation( )->get_aggregated_elements( ).
    gv_top           = io_request->get_paging( )->get_page_size( ).
    gv_skip          = io_request->get_paging( )->get_offset( ).
    gt_grouped_element = io_request->get_aggregation( )->get_grouped_elements(  ).
    gv_max_rows = COND #( WHEN gv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE gv_top ).

    IF gv_max_rows = -1 .
      gv_max_rows = 1.
    ENDIF.
    IF gt_aggr_element IS NOT INITIAL.
      LOOP AT gt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
        DELETE gt_fields WHERE table_line = <fs_aggr_element>-result_element.
        DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
        APPEND lv_aggregation TO gt_fields.
      ENDLOOP.
    ENDIF.



*        DATA(LT_GROUPED_ELEMENT) = IO_REQUEST->GET_AGGREGATION( )->GET_GROUPED_ELEMENTS( ).
*        LV_GROUPING = CONCAT_LINES_OF( TABLE = LT_GROUPED_ELEMENT SEP = `, ` ).

  ENDMETHOD.
ENDCLASS.
