(* ◆aiai/zdSWk *)
// ThemeのiPartとiStateの定義ファイル 
// PlatformSDKのTmschema.hをPascalで書いた

unit JLTmschema;

interface

const
//---------------------------------------------------------------------------------------
//   "Window" (i.e., non-client) Parts & States
//
//    these cannot be renumbered (part of uxtheme API)
//---------------------------------------------------------------------------------------
  WP_CAPTION						= 1;
  WP_SMALLCAPTION					= 2;
  WP_MINCAPTION						= 3;
  WP_SMALLMINCAPTION				= 4;
  WP_MAXCAPTION						= 5;
  WP_SMALLMAXCAPTION				= 6;
  WP_FRAMELEFT						= 7;
  WP_FRAMERIGHT						= 8;
  WP_FRAMEBOTTOM					= 9;
  WP_SMALLFRAMELEFT					= 10;
  WP_SMALLFRAMERIGHT				= 11;
  WP_SMALLFRAMEBOTTOM				= 12;
  //---- window frame buttons ----
  WP_SYSBUTTON						= 13;
  WP_MDISYSBUTTON					= 14;
  WP_MINBUTTON						= 15;
  WP_MDIMINBUTTON					= 16;
  WP_MAXBUTTON						= 17;
  WP_CLOSEBUTTON					= 18;
  WP_SMALLCLOSEBUTTON				= 19;
  WP_MDICLOSEBUTTON					= 20;
  WP_RESTOREBUTTON					= 21;
  WP_MDIRESTOREBUTTON				= 22;
  WP_HELPBUTTON						= 23;
  WP_MDIHELPBUTTON					= 24;
  //---- scrollbars 
  WP_HORZSCROLL						= 25;
  WP_HORZTHUMB						= 26;
  WP_VERTSCROLL						= 27;
  WP_VERTTHUMB						= 28;
  //---- dialog ----
  WP_DIALOG							= 29;
  //---- hit-test templates ---
  WP_CAPTIONSIZINGTEMPLATE			= 30;
  WP_SMALLCAPTIONSIZINGTEMPLATE		= 31;
  WP_FRAMELEFTSIZINGTEMPLATE		= 32;
  WP_SMALLFRAMELEFTSIZINGTEMPLATE	= 33;
  WP_FRAMERIGHTSIZINGTEMPLATE		= 34;
  WP_SMALLFRAMERIGHTSIZINGTEMPLATE	= 35;
  WP_FRAMEBOTTOMSIZINGTEMPLATE		= 36;
  WP_SMALLFRAMEBOTTOMSIZINGTEMPLATE	= 37;

//FRAME STATES
  FS_ACTIVE		= 1;
  FS_INACTIVE	= 2;

//CAPTION STATES
  CS_ACTIVE		= 1;
  CS_INACTIVE	= 2;
  CS_DISABLED	= 3;
    
//MAXCAPTION STATES
  MXCS_ACTIVE		= 1;
  MXCS_INACTIVE		= 2;
  MXCS_DISABLED		= 3;

//MINCAPTION STATES
  MNCS_ACTIVE		= 1;
  MNCS_INACTIVE		= 2;
  MNCS_DISABLED		= 3;

//HORZSCROLL STATES
  HSS_NORMAL	= 1;
  HSS_HOT		= 2;
  HSS_PUSHED	= 3;
  HSS_DISABLED	= 4;

//HORZTHUMB STATES
  HTS_NORMAL	= 1;
  HTS_HOT		= 2;
  HTS_PUSHED	= 3;
  HTS_DISABLED	= 4;

//VERTSCROLL STATES
  VSS_NORMAL	= 1;
  VSS_HOT		= 2;
  VSS_PUSHED	= 3;
  VSS_DISABLED	= 4;

//VERTTHUMB STATES
  VTS_NORMAL	= 1;
  VTS_HOT		= 2;
  VTS_PUSHED	= 3;
  VTS_DISABLED	= 4;

//SYSBUTTON STATES
  SBS_NORMAL		= 1;
  SBS_HOT			= 2;
  SBS_PUSHED		= 3;
  SBS_DISABLED		= 4;

//MINBUTTON STATES
  MINBS_NORMAL		= 1;
  MINBS_HOT			= 2;
  MINBS_PUSHED		= 3;
  MINBS_DISABLED	= 4;

//MAXBUTTON STATES
  MAXBS_NORMAL		= 1;
  MAXBS_HOT			= 2;
  MAXBS_PUSHED		= 3;
  MAXBS_DISABLED	= 4;

//RESTOREBUTTON STATES
  RBS_NORMAL	= 1;
  RBS_HOT		= 2;
  RBS_PUSHED	= 3;
  RBS_DISABLED	= 4;

//HELPBUTTON STATES
  HBS_NORMAL	= 1;
  HBS_HOT		= 2;
  HBS_PUSHED	= 3;
  HBS_DISABLED	= 4;

//CLOSEBUTTON STATES
  CBS_NORMAL	= 1;
  CBS_HOT		= 2;
  CBS_PUSHED	= 3;
  CBS_DISABLED	= 4;





//---------------------------------------------------------------------------------------
//   "Button" Parts & States
//---------------------------------------------------------------------------------------
  BP_PUSHBUTTON		= 1;
  BP_RADIOBUTTON	= 2;
  BP_CHECKBOX		= 3;
  BP_GROUPBOX		= 4;
  BP_USERBUTTON		= 5;

//PUSHBUTTON STATES

  PBS_NORMAL		= 1;
  PBS_HOT			= 2;
  PBS_PRESSED		= 3;
  PBS_DISABLED		= 4;
  PBS_DEFAULTED		= 5;

//RADIOBUTTON STATES

  RBS_UNCHECKEDNORMAL	= 1;
  RBS_UNCHECKEDHOT		= 2;
  RBS_UNCHECKEDPRESSED	= 3;
  RBS_UNCHECKEDDISABLED	= 4;
  RBS_CHECKEDNORMAL		= 5;
  RBS_CHECKEDHOT		= 6;
  RBS_CHECKEDPRESSED	= 7;
  RBS_CHECKEDDISABLED	= 8;

//CHECKBOX STATES

  CBS_UNCHECKEDNORMAL		= 1;
  CBS_UNCHECKEDHOT			= 2;
  CBS_UNCHECKEDPRESSED		= 3;
  CBS_UNCHECKEDDISABLED		= 4;
  CBS_CHECKEDNORMAL			= 5;
  CBS_CHECKEDHOT			= 6;
  CBS_CHECKEDPRESSED		= 7;
  CBS_CHECKEDDISABLED		= 8;
  CBS_MIXEDNORMAL			= 9;
  CBS_MIXEDHOT				= 10;
  CBS_MIXEDPRESSED			= 11;
  CBS_MIXEDDISABLED			= 12;

//GROUPBOX STATES

  GBS_NORMAL	= 1;
  GBS_DISABLED	= 2;




//---------------------------------------------------------------------------------------
//   "Rebar" Parts & States
//---------------------------------------------------------------------------------------
  RP_GRIPPER		= 1;
  RP_GRIPPERVERT	= 2;
  RP_BAND			= 3;
  RP_CHEVRON		= 4;
  RP_CHEVRONVERT	= 5;

//CHEVRON STATES

  CHEVS_NORMAL		= 1;
  CHEVS_HOT			= 2;
  CHEVS_PRESSED		= 3;





//---------------------------------------------------------------------------------------
//   "Toolbar" Parts & States
//---------------------------------------------------------------------------------------
  TP_BUTTON					= 1;
  TP_DROPDOWNBUTTON			= 2;
  TP_SPLITBUTTON			= 3;
  TP_SPLITBUTTONDROPDOWN	= 4;
  TP_SEPARATOR				= 5;
  TP_SEPARATORVERT			= 6;

//TOOLBAR STATES
  TS_NORMAL		= 1;
  TS_HOT		= 2;
  TS_PRESSED	= 3;
  TS_DISABLED	= 4;
  TS_CHECKED	= 5;
  TS_HOTCHECKED	= 6;







//---------------------------------------------------------------------------------------
//   "Status" Parts & States
//---------------------------------------------------------------------------------------
  SP_PANE			= 1;
  SP_GRIPPERPANE	= 2;
  SP_GRIPPER		= 3;








//---------------------------------------------------------------------------------------
//   "Menu" Parts & States
//---------------------------------------------------------------------------------------
  MP_MENUITEM			= 1;
  MP_MENUDROPDOWN		= 2;
  MP_MENUBARITEM		= 3;
  MP_MENUBARDROPDOWN	= 4;
  MP_CHEVRON			= 5;
  MP_SEPARATOR			= 6;


//Menu STATES 

  MS_NORMAL		= 1;
  MS_SELECTED	= 2;
  MS_DEMOTED	= 3;






//---------------------------------------------------------------------------------------
//   "ListView" Parts & States
//---------------------------------------------------------------------------------------
  LVP_LISTITEM			= 1;
  LVP_LISTGROUP			= 2;
  LVP_LISTDETAIL		= 3;
  LVP_LISTSORTEDDETAIL	= 4;
  LVP_EMPTYTEXT			= 5;

//LISTITEM STATES

  LIS_NORMAL			= 1;
  LIS_HOT				= 2;
  LIS_SELECTED			= 3;
  LIS_DISABLED			= 4;
  LIS_SELECTEDNOTFOCUS	= 5;








//---------------------------------------------------------------------------------------
//   "Header" Parts & States
//---------------------------------------------------------------------------------------
  HP_HEADERITEM			= 1;
  HP_HEADERITEMLEFT		= 2;
  HP_HEADERITEMRIGHT	= 3;
  HP_HEADERSORTARROW	= 4;

//HEADERITEM STATES

  HIS_NORMAL	= 1;
  HIS_HOT		= 2;
  HIS_PRESSED	= 3;

//HEADERITEMLEFT STATES

  HILS_NORMAL	= 1;
  HILS_HOT		= 2;
  HILS_PRESSED	= 3;

//HEADERITEMRIGHT STATES

  HIRS_NORMAL		= 1;
  HIRS_HOT			= 2;
  HIRS_PRESSED		= 3;

//HEADERSORTARROW STATES

  HSAS_SORTEDUP		= 1;
  HSAS_SORTEDDOWN	= 2;







//---------------------------------------------------------------------------------------
//   "Progress" Parts & States
//---------------------------------------------------------------------------------------
  PP_BAR		= 1;
  PP_BARVERT	= 2;
  PP_CHUNK		= 3;
  PP_CHUNKVERT	= 4;










//---------------------------------------------------------------------------------------
//   "Tab" Parts & States
//---------------------------------------------------------------------------------------
  TABP_TABITEM				= 1;
  TABP_TABITEMLEFTEDGE		= 2;
  TABP_TABITEMRIGHTEDGE		= 3;
  TABP_TABITEMBOTHEDGE		= 4;
  TABP_TOPTABITEM			= 5;
  TABP_TOPTABITEMLEFTEDGE	= 6;
  TABP_TOPTABITEMRIGHTEDGE	= 7;
  TABP_TOPTABITEMBOTHEDGE	= 8;
  TABP_PANE					= 9;
  TABP_BODY					= 10;

//TABITEM STATES

  TIS_NORMAL	= 1;
  TIS_HOT		= 2;
  TIS_SELECTED	= 3;
  TIS_DISABLED	= 4;
  TIS_FOCUSED	= 5;

//TABITEMLEFTEDGE STATES

  TILES_NORMAL		= 1;
  TILES_HOT			= 2;
  TILES_SELECTED	= 3;
  TILES_DISABLED	= 4;
  TILES_FOCUSED		= 5;

//TABITEMRIGHTEDGE STATES

  TIRES_NORMAL		= 1;
  TIRES_HOT			= 2;
  TIRES_SELECTED	= 3;
  TIRES_DISABLED	= 4;
  TIRES_FOCUSED		= 5;

//TABITEMBOTHEDGES STATES

  TIBES_NORMAL		= 1;
  TIBES_HOT			= 2;
  TIBES_SELECTED	= 3;
  TIBES_DISABLED	= 4;
  TIBES_FOCUSED		= 5;

//TOPTABITEM STATES

  TTIS_NORMAL		= 1;
  TTIS_HOT			= 2;
  TTIS_SELECTED		= 3;
  TTIS_DISABLED		= 4;
  TTIS_FOCUSED		= 5;

//TOPTABITEMLEFTEDGE STATES

  TTILES_NORMAL		= 1;
  TTILES_HOT		= 2;
  TTILES_SELECTED	= 3;
  TTILES_DISABLED	= 4;
  TTILES_FOCUSED	= 5;

//TOPTABITEMRIGHTEDGE STATES

  TTIRES_NORMAL		= 1;
  TTIRES_HOT		= 2;
  TTIRES_SELECTED	= 3;
  TTIRES_DISABLED	= 4;
  TTIRES_FOCUSED	= 5;

//TOPTABITEMBOTHEDGES STATES

  TTIBES_NORMAL		= 1;
  TTIBES_HOT		= 2;
  TTIBES_SELECTED	= 3;
  TTIBES_DISABLED	= 4;
  TTIBES_FOCUSED	= 5;









//---------------------------------------------------------------------------------------
//   "Trackbar" Parts & States
//---------------------------------------------------------------------------------------
  TKP_TRACK			= 1;
  TKP_TRACKVERT		= 2;
  TKP_THUMB			= 3;
  TKP_THUMBBOTTOM	= 4;
  TKP_THUMBTOP		= 5;
  TKP_THUMBVERT		= 6;
  TKP_THUMBLEFT		= 7;
  TKP_THUMBRIGHT	= 8;
  TKP_TICS			= 9;
  TKP_TICSVERT		= 10;

//TRACKBAR STATES

  TKS_NORMAL = 1;

//TRACK STATES

  TRS_NORMAL = 1;

//TRACKVERT STATES

  TRVS_NORMAL = 1;

//THUMB STATES

  TUS_NORMAL	= 1;
  TUS_HOT		= 2;
  TUS_PRESSED	= 3;
  TUS_FOCUSED	= 4;
  TUS_DISABLED	= 5;

//THUMBBOTTOM STATES

  TUBS_NORMAL		= 1;
  TUBS_HOT			= 2;
  TUBS_PRESSED		= 3;
  TUBS_FOCUSED		= 4;
  TUBS_DISABLED		= 5;

//THUMBTOP STATES

  TUTS_NORMAL		= 1;
  TUTS_HOT			= 2;
  TUTS_PRESSED		= 3;
  TUTS_FOCUSED		= 4;
  TUTS_DISABLED		= 5;

//THUMBVERT STATES

  TUVS_NORMAL		= 1;
  TUVS_HOT			= 2;
  TUVS_PRESSED		= 3;
  TUVS_FOCUSED		= 4;
  TUVS_DISABLED		= 5;

//THUMBLEFT STATES

  TUVLS_NORMAL		= 1;
  TUVLS_HOT			= 2;
  TUVLS_PRESSED		= 3;
  TUVLS_FOCUSED		= 4;
  TUVLS_DISABLED	= 5;

//THUMBRIGHT STATES

  TUVRS_NORMAL		= 1;
  TUVRS_HOT			= 2;
  TUVRS_PRESSED		= 3;
  TUVRS_FOCUSED		= 4;
  TUVRS_DISABLED	= 5;

//TICS STATES

  TSS_NORMAL = 1;

//TICSVERT STATES

  TSVS_NORMAL = 1;












//---------------------------------------------------------------------------------------
//   "Tooltips" Parts & States
//---------------------------------------------------------------------------------------
  TTP_STANDARD			= 1;
  TTP_STANDARDTITLE		= 2;
  TTP_BALLOON			= 3;
  TTP_BALLOONTITLE		= 4;
  TTP_CLOSE				= 5;

//CLOSE STATES

  TTCS_NORMAL	= 1;
  TTCS_HOT		= 2;
  TTCS_PRESSED	= 3;

//STANDARD STATES

  TTSS_NORMAL	= 1;
  TTSS_LINK		= 2;

//BALLOON STATES

  TTBS_NORMAL	= 1;
  TTBS_LINK		= 2;








//---------------------------------------------------------------------------------------
//   "TreeView" Parts & States
//---------------------------------------------------------------------------------------
  TVP_TREEITEM	= 1;
  TVP_GLYPH		= 2;
  TVP_BRANCH	= 3;

//TREEITEM STATES

  TREIS_NORMAL				= 1;
  TREIS_HOT					= 2;
  TREIS_SELECTED			= 3;
  TREIS_DISABLED			= 4;
  TREIS_SELECTEDNOTFOCUS	= 5;

//GLYPH STATES

  GLPS_CLOSED	= 1;
  GLPS_OPENED	= 2;




//---------------------------------------------------------------------------------------
//   "Spin" Parts & States
//---------------------------------------------------------------------------------------
  SPNP_UP			= 1;
  SPNP_DOWN			= 2;
  SPNP_UPHORZ		= 3;
  SPNP_DOWNHORZ		= 4;

//UP STATES

  UPS_NORMAL	= 1;
  UPS_HOT		= 2;
  UPS_PRESSED	= 3;
  UPS_DISABLED	= 4;

//DOWN STATES

  DNS_NORMAL	= 1;
  DNS_HOT		= 2;
  DNS_PRESSED	= 3;
  DNS_DISABLED	= 4;

//UPHORZ STATES

  UPHZS_NORMAL		= 1;
  UPHZS_HOT			= 2;
  UPHZS_PRESSED		= 3;
  UPHZS_DISABLED	= 4;

//DOWNHORZ STATES

  DNHZS_NORMAL		= 1;
  DNHZS_HOT			= 2;
  DNHZS_PRESSED		= 3;
  DNHZS_DISABLED	= 4;





//---------------------------------------------------------------------------------------
//   "Page" Parts & States
//---------------------------------------------------------------------------------------
  PGRP_UP			= 1;
  PGRP_DOWN			= 2;
  PGRP_UPHORZ		= 3;
  PGRP_DOWNHORZ		= 4;

//--- Pager uses same states as Spin ---








//---------------------------------------------------------------------------------------
//   "Scrollbar" Parts & States
//---------------------------------------------------------------------------------------
  SBP_ARROWBTN			= 1;
  SBP_THUMBBTNHORZ		= 2;
  SBP_THUMBBTNVERT		= 3;
  SBP_LOWERTRACKHORZ	= 4;
  SBP_UPPERTRACKHORZ	= 5;
  SBP_LOWERTRACKVERT	= 6;
  SBP_UPPERTRACKVERT	= 7;
  SBP_GRIPPERHORZ		= 8;
  SBP_GRIPPERVERT		= 9;
  SBP_SIZEBOX			= 10;

//ARROWBTN STATES

  ABS_UPNORMAL		= 1;
  ABS_UPHOT			= 2;
  ABS_UPPRESSED		= 3;
  ABS_UPDISABLED	= 4;
  ABS_DOWNNORMAL	= 5;
  ABS_DOWNHOT		= 6;
  ABS_DOWNPRESSED	= 7;
  ABS_DOWNDISABLED	= 8;
  ABS_LEFTNORMAL	= 9;
  ABS_LEFTHOT		= 10;
  ABS_LEFTPRESSED	= 11;
  ABS_LEFTDISABLED	= 12;
  ABS_RIGHTNORMAL	= 13;
  ABS_RIGHTHOT		= 14;
  ABS_RIGHTPRESSED	= 15;
  ABS_RIGHTDISABLED	= 16;

//SCROLLBAR STATES

  SCRBS_NORMAL		= 1;
  SCRBS_HOT			= 2;
  SCRBS_PRESSED		= 3;
  SCRBS_DISABLED	= 4;

//SIZEBOX STATES

  SZB_RIGHTALIGN	= 1;
  SZB_LEFTALIGN		= 2;




//---------------------------------------------------------------------------------------
//   "Edit" Parts & States
//---------------------------------------------------------------------------------------
  EP_EDITTEXT	= 1;
  EP_CARET		= 2;

//EDITTEXT STATES

  ETS_NORMAL	= 1;
  ETS_HOT		= 2;
  ETS_SELECTED	= 3;
  ETS_DISABLED	= 4;
  ETS_FOCUSED	= 5;
  ETS_READONLY	= 6;
  ETS_ASSIST	= 7;






//---------------------------------------------------------------------------------------
//   "ComboBox" Parts & States
//---------------------------------------------------------------------------------------
  CP_DROPDOWNBUTTON	= 1;

//COMBOBOX STATES

  CBXS_NORMAL		= 1;
  CBXS_HOT			= 2;
  CBXS_PRESSED		= 3;
  CBXS_DISABLED		= 4;






//---------------------------------------------------------------------------------------
//   "Taskbar Clock" Parts & States
//---------------------------------------------------------------------------------------
   CLP_TIME = 1;

//CLOCK STATES

   CLS_NORMAL = 1;





//---------------------------------------------------------------------------------------
//   "Tray Notify" Parts & States
//---------------------------------------------------------------------------------------
  TNP_BACKGROUND		= 1;
  TNP_ANIMBACKGROUND	= 2;





//---------------------------------------------------------------------------------------
//   "TaskBar" Parts & States
//---------------------------------------------------------------------------------------
  TBP_BACKGROUNDBOTTOM	= 1;
  TBP_BACKGROUNDRIGHT	= 2;
  TBP_BACKGROUNDTOP		= 3;
  TBP_BACKGROUNDLEFT	= 4;
  TBP_SIZINGBARBOTTOM	= 5;
  TBP_SIZINGBARRIGHT	= 6;
  TBP_SIZINGBARTOP		= 7;
  TBP_SIZINGBARLEFT		= 8;






//---------------------------------------------------------------------------------------
//   "TaskBand" Parts & States
//---------------------------------------------------------------------------------------
  TDP_GROUPCOUNT			= 1;
  TDP_FLASHBUTTON			= 2;
  TDP_FLASHBUTTONGROUPMENU	= 3;






//---------------------------------------------------------------------------------------
//   "StartPanel" Parts & States
//---------------------------------------------------------------------------------------
  SPP_USERPANE				= 1;
  SPP_MOREPROGRAMS			= 2;
  SPP_MOREPROGRAMSARROW		= 3;
  SPP_PROGLIST				= 4;
  SPP_PROGLISTSEPARATOR		= 5;
  SPP_PLACESLIST			= 6;
  SPP_PLACESLISTSEPARATOR	= 7;
  SPP_LOGOFF				= 8;
  SPP_LOGOFFBUTTONS			= 9;
  SPP_USERPICTURE			= 10;
  SPP_PREVIEW				= 11;


//MOREPROGRAMSARROW STATES

  SPS_NORMAL	= 1;
  SPS_HOT		= 2;
  SPS_PRESSED	= 3;

//LOGOFFBUTTONS STATES

  SPLS_NORMAL		= 1;
  SPLS_HOT			= 2;
  SPLS_PRESSED		= 3;












//---------------------------------------------------------------------------------------
//   "ExplorerBar" Parts & States
//---------------------------------------------------------------------------------------
  EBP_HEADERBACKGROUND			= 1;
  EBP_HEADERCLOSE				= 2;
  EBP_HEADERPIN					= 3;
  EBP_IEBARMENU					= 4;
  EBP_NORMALGROUPBACKGROUND		= 5;
  EBP_NORMALGROUPCOLLAPSE		= 6;
  EBP_NORMALGROUPEXPAND			= 7;
  EBP_NORMALGROUPHEAD			= 8;
  EBP_SPECIALGROUPBACKGROUND	= 9;
  EBP_SPECIALGROUPCOLLAPSE		= 10;
  EBP_SPECIALGROUPEXPAND		= 11;
  EBP_SPECIALGROUPHEAD			= 12;

//HEADERCLOSE STATES

  EBHC_NORMAL	= 1;
  EBHC_HOT		= 2;
  EBHC_PRESSED	= 3;

//HEADERPIN STATES

  EBHP_NORMAL			= 1;
  EBHP_HOT				= 2;
  EBHP_PRESSED			= 3;
  EBHP_SELECTEDNORMAL	= 4;
  EBHP_SELECTEDHOT		= 5;
  EBHP_SELECTEDPRESSED	= 6;

//IEBARMENU STATES

  EBM_NORMAL	= 1;
  EBM_HOT		= 2;
  EBM_PRESSED	= 3;

//NORMALGROUPCOLLAPSE STATES

  EBNGC_NORMAL		= 1;
  EBNGC_HOT			= 2;
  EBNGC_PRESSED		= 3;

//NORMALGROUPEXPAND STATES

  EBNGE_NORMAL		= 1;
  EBNGE_HOT			= 2;
  EBNGE_PRESSED		= 3;

//SPECIALGROUPCOLLAPSE STATES

  EBSGC_NORMAL		= 1;
  EBSGC_HOT			= 2;
  EBSGC_PRESSED		= 3;

//SPECIALGROUPEXPAND STATES

  EBSGE_NORMAL		= 1;
  EBSGE_HOT			= 2;
  EBSGE_PRESSED		= 3;




//---------------------------------------------------------------------------------------
//   "TaskBand" Parts & States
//---------------------------------------------------------------------------------------
  MDP_NEWAPPBUTTON	= 1;
  MDP_SEPERATOR		= 2;

//MENUBAND STATES

  MDS_NORMAL		= 1;
  MDS_HOT			= 2;
  MDS_PRESSED		= 3;
  MDS_DISABLED		= 4;
  MDS_CHECKED		= 5;
  MDS_HOTCHECKED	= 6;

implementation

end.