"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>YY1_WAREHOUSENUMBERTEXT_CDS</em>
CLASS zscm_im_bctkttt_whnt DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">YY1_WarehouseNumberTextType</p>
      BEGIN OF tys_yy_1_warehouse_number_te_2,
        "! <em>Key property</em> EWMWarehouse
        ewmwarehouse             TYPE c LENGTH 4,
        "! <em>Key property</em> Language
        language                 TYPE c LENGTH 2,
        "! <em>Key property</em> EWMWarehouseDescription
        ewmwarehouse_description TYPE c LENGTH 40,
      END OF tys_yy_1_warehouse_number_te_2,
      "! <p class="shorttext synchronized">List of YY1_WarehouseNumberTextType</p>
      tyt_yy_1_warehouse_number_te_2 TYPE STANDARD TABLE OF tys_yy_1_warehouse_number_te_2 WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! YY1_WarehouseNumberText
        "! <br/> Collection of type 'YY1_WarehouseNumberTextType'
        yy_1_warehouse_number_text TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'YY_1_WAREHOUSE_NUMBER_TEXT',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for YY1_WarehouseNumberTextType</p>
        "! See also structure type {@link ..tys_yy_1_warehouse_number_te_2}
        BEGIN OF yy_1_warehouse_number_te_2,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF yy_1_warehouse_number_te_2,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define YY1_WarehouseNumberTextType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_yy_1_warehouse_number_te_2 RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZSCM_IM_BCTKTTT_WHNT IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'YY1_WAREHOUSENUMBERTEXT_CDS' ).

    def_yy_1_warehouse_number_te_2( ).

  ENDMETHOD.


  METHOD def_yy_1_warehouse_number_te_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'YY_1_WAREHOUSE_NUMBER_TE_2'
                                    is_structure              = VALUE tys_yy_1_warehouse_number_te_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'YY1_WarehouseNumberTextType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'YY_1_WAREHOUSE_NUMBER_TEXT' ).
    lo_entity_set->set_edm_name( 'YY1_WarehouseNumberText' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'EWMWAREHOUSE' ).
    lo_primitive_property->set_edm_name( 'EWMWarehouse' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE' ).
    lo_primitive_property->set_edm_name( 'Language' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EWMWAREHOUSE_DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'EWMWarehouseDescription' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

  ENDMETHOD.
ENDCLASS.
