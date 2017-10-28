
;********************************
; LAYER DEFINITION
;********************************
layerDefinitions(

 techPurposes(
 ;( PurposeName               Purpose#   Abbreviation )
 ;( -----------               --------   ------------ )
  ( drawing                   252        drw          )
  ( net                       253        net          )
 ) ;techPurposes

 techLayers(
 ;( LayerName                 Layer#     Abbreviation )
 ;( ---------                 ------     ------------ )
 ;User-Defined Layers:
  ( PW                        1          PW           )
  ( NBL                       2          NBL          )
  ( SP                        3          SP           )
  ( PBL                       6          PBL          )
  ( C1                        9          C1           )
  ( M1                        10         M1           )
  ( PA                        11         PA           )
  ( NW                        12         NW           )
  ( NHV                       23         NHV          )
  ( PHV                       24         PHV          )
  ( PTOP                      25         PTOP         )
  ( P1                        30         P1           )
  ( P2                        31         P2           )
  ( AA                        54         AA           )
  ( VTH                       91         VTH          )
  ( PP                        97         PP           )
  ( NP                        98         NP           )
 ) ;techLayers

 techLayerPurposePriorities(
 ;layers are ordered from lowest to highest priority
 ;( LayerName                 Purpose    )
 ;( ---------                 -------    )
  ( NBL                       drawing    )
  ( PBL                       drawing    )
  ( PW                        drawing    )
  ( NW                        drawing    )
  ( PTOP                      drawing    )
  ( AA                        drawing    )
  ( VTH                       drawing    )
  ( P1                        drawing    )
  ( NHV                       drawing    )
  ( PHV                       drawing    )
  ( SP                        drawing    )
  ( P2                        drawing    )
  ( NP                        drawing    )
  ( PP                        drawing    )
  ( C1                        drawing    )
  ( M1                        drawing    )
  ( PA                        drawing    )
  ( P1                        net        )
  ( P2                        net        )
  ( C1                        net        )
  ( M1                        net        )
 ) ;techLayerPurposePriorities

 techDisplays(
 ;( LayerName    Purpose      Packet          Vis Sel Con2ChgLy DrgEnbl Valid )
 ;( ---------    -------      ------          --- --- --------- ------- ----- )
  ( NBL          drawing      NBL              t t t t t )
  ( PBL          drawing      PBL              t t t t t )
  ( PW           drawing      PW               t t t t t )
  ( NW           drawing      NW               t t t t t )
  ( PTOP         drawing      PTOP             t t t t t )
  ( AA           drawing      AA               t t t t t )
  ( VTH          drawing      VTH              t t t t t )
  ( P1           drawing      P1               t t t t t )
  ( NHV          drawing      NHV              t t t t t )
  ( PHV          drawing      PHV              t t t t t )
  ( SP           drawing      SP               t t t t t )
  ( P2           drawing      P2               t t t t t )
  ( NP           drawing      NP               t t t t t )
  ( PP           drawing      PP               t t t t t )
  ( C1           drawing      C1               t t t t t )
  ( M1           drawing      M1               t t t t t )
  ( PA           drawing      PA               t t t t t )
  ( P1           net          P1net            t t t t nil )
  ( P2           net          P2net            t t t t nil )
  ( C1           net          C1net            t t t t nil )
  ( M1           net          M1net            t t t t nil )
 ) ;techDisplays

techLayerProperties(
;( PropName               Layer1 [ Layer2 ]            PropValue )
)

) ;layerDefinitions


;********************************
; LAYER RULES
;********************************
layerRules(

 streamLayers(
 ;( layer       streamNumber    dataType        translate )
 ;( -----       ------------    --------        --------- )
  ( ("NBL" "drawing")	2         	0       	t	 )
  ( ("PBL" "drawing")	6         	0       	t	 )
  ( ("PW" "drawing")	1         	0       	t	 )
  ( ("NW" "drawing")	12        	0       	t	 )
  ( ("PTOP" "drawing")	25        	0       	t	 )
  ( ("AA" "drawing")	54        	0       	t	 )
  ( ("VTH" "drawing")	91        	0       	t	 )
  ( ("P1" "drawing")	30        	0       	t	 )
  ( ("NHV" "drawing")	23        	0       	t	 )
  ( ("PHV" "drawing")	24        	0       	t	 )
  ( ("SP" "drawing")	3         	0       	t	 )
  ( ("P2" "drawing")	31        	0       	t	 )
  ( ("NP" "drawing")	98        	0       	t	 )
  ( ("PP" "drawing")	97        	0       	t	 )
  ( ("C1" "drawing")	9         	0       	t	 )
  ( ("M1" "drawing")	10        	0       	t	 )
  ( ("PA" "drawing")	11        	0       	t	 )
  ( ("P2" "net")	101       	0       	t	 )
  ( ("P1" "net")	102       	0       	t	 )
  ( ("M1" "net")	103       	0       	t	 )
  ( ("C1" "net")	104       	0       	t	 )
 ) ;streamLayers

) ;layerRules


;********************************
; PHYSICAL RULES
;********************************
physicalRules(

 mfgGridResolution(
      ( 0.001000 )
 ) ;mfgGridResolution

) ;physicalRules
