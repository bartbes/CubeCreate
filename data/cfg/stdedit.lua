CV:run([[
// implements some editing commands


//////// Entity Editing ///////////////

// the entity type of current selection
et = [ at (entget) 0 ]

// access the given attribute of selected ent
ea = [ at (entget) (+ $arg1 1) ]

// clear ents of given type
clearents = [ 
  if $editing [
    entcancel
    entselect [ strcmp (et) $arg1 ]; 
    echo Deleted (enthavesel) $arg1 entities; 
    delent
  ] 
]

// replace all ents that match current selection
// with the values given
replaceents = [
  if $editing [
    entfind @(entget)
    entset @arg1 @arg2 @arg3 @arg4 @arg5
    echo Replaced (enthavesel) entities  
  ]
]

selentedit      = [ "saycommand" ( concatword "/entset " (entget) ) ] 
selreplaceents  = [ "saycommand" ( concatword "/replaceents " (entget) ) ]  
selentfindall   = [ do [ @( concatword "entfind " (entget) ) ] ]

// modify given attribute of ent by a given amount
// arg1 attribute
// arg2 value
entproperty = [
  entloop [
    a0 = (ea 0)
    a1 = (ea 1)
    a2 = (ea 2)
    a3 = (ea 3)
    a4 = (ea 4)
    do [a@arg1 = (+ (ea @arg1) @arg2)]
    entset (et) $a0 $a1 $a2 $a3 $a4
  ]
]

listindex = [
  s = 0
  n = (listlen $arg1)
  loop i $n [
    if (strcmp $arg2 (at $arg1 $i)) [
      s = $i
    ]
  ]
  result $s
]

////// Entity primary actions /////////

ent_action_base           = [ entproperty 0 ( * $arg1 1 ) ]
ent_action_teleport       = [ entproperty 0 ( * $arg1 1 ) ]
ent_action_teledest       = [ entproperty 1 ( * $arg1 1 ) ]
ent_action_mapmodel       = [ entproperty 1 ( * $arg1 1 ) ]
ent_action_mapmodel       = [ entproperty 1 ( * $arg1 1 ) ]
ent_action_spotlight      = [ entproperty 0 ( * $arg1 5 ) ]
ent_action_light          = [ entproperty 0 ( * $arg1 5 ) ]
ent_action_jumppad        = [ entproperty 0 ( * $arg1 5 ) ]
ent_action_playerstart    = [ entproperty 0 ( * $arg1 15 ) ]
ent_action_envmap         = [ entproperty 0 ( * $arg1 5 ) ]
ent_action_particles      = [ entproperty 0 ( * $arg1 1 ) ]
ent_action_sound          = [ entproperty 0 ( * $arg1 1 ) ]
ent_action_cycle          = [ entset ( if ( > $arg1 -1 ) [ result $arg2 ] [ result $arg3 ] ) ]

//////// Copy and Paste //////////////

// 3 types of copying and pasting
// 1. select only cubes      -> paste only cubes
// 2. select cubes and ents  -> paste cubes and ents. same relative positions
// 3. select only ents       -> paste last selected ent. if ents are selected, replace attrs as paste

opaquepaste = 1
entcopybuf = ""

entreplace   = [ 
  do [
    if (enthavesel) [] [
        save_mouse_pos // INTENSITY: Place new entity right here
        intensitypasteent // INTENSITY: Using our newent here
    ]
    entset @entcopybuf // INTENSITY: Kill this? XXX
  ]
]

editcopy   = [
  if (|| havesel [! (enthavesel)]) [
    entcopybuf = ""
    entcopy
    copy
  ] [
    entcopybuf = (entget)
    intensityentcopy // INTENSITY
  ]
]

editpaste  = [ 
  cancelpaste = (! (|| enthavesel havesel));
  if (strcmp "" $entcopybuf) [
    pastehilite
    reorient // temp; real fix will be in octaedit
    onrelease [ 
      if (opaquepaste) delcube 
      paste
      entpaste
      if ($cancelpaste) [ cancelsel ] 
    ] 
  ] [
    entreplace
    if ($cancelpaste) [ cancelsel ] 
  ] 
]

/////// Selection ///////////////

equaltype  = [
  if (strcmp * $arg1) [ result 1 ] [
    result (strcmp (et) $arg1)
  ]
]

equalattr  = [
  if (strcmp * $arg2) [ result 1 ] [
    result (= (ea $arg1) $arg2)
  ]
]

// select ents with given properties
// '*' is wildcard
entfind    = [ 
  if (= $numargs 1) [
    entselect     [ equaltype @@arg1 ]     
  ] [ if (= $numargs 2) [
    entselect [ && (equaltype @@arg1) [equalattr 0 @@arg2] ]
  ] [ if (= $numargs 3) [
    entselect [ && (equaltype @@arg1) [equalattr 0 @@arg2] [equalattr 1 @@arg3] ]
  ] [ if (= $numargs 4) [
    entselect [ && (equaltype @@arg1) [equalattr 0 @@arg2] [equalattr 1 @@arg3] [equalattr 2 @@arg4] ]
  ] [
    entselect [ && (equaltype @@arg1) [equalattr 0 @@arg2] [equalattr 1 @@arg3] [equalattr 2 @@arg4] [equalattr 3 @@arg5] ]
  ] ] ] ]
]

entfindinsel = [ 
  if (= $numargs 1) [
    entselect [ && (insel) [equaltype @@arg1] ]
  ] [ if (= $numargs 2) [
    entselect [ && (insel) [equaltype @@arg1] [equalattr 0 @@arg2] ]
  ] [ if (= $numargs 3) [
    entselect [ && (insel) [equaltype @@arg1] [equalattr 0 @@arg2] [equalattr 1 @@arg3] ]
  ] [ if (= $numargs 4) [
    entselect [ && (insel) [equaltype @@arg1] [equalattr 0 @@arg2] [equalattr 1 @@arg3] [equalattr 2 @@arg4] ]
  ] [
    entselect [ && (insel) [equaltype @@arg1] [equalattr 0 @@arg2] [equalattr 1 @@arg3] [equalattr 2 @@arg4] [equalattr 3 @@arg5] ]
  ] ] ] ]
]

lse        = [
  line = ""
  count = 0
  entloop [
    line  = ( concatword $line (entget) "		" )
    count = ( + $count 1 )
    if (> $count 4) [
      echo $line
      line = ""
      count = 0
    ]
  ]
  if (> $count 0 ) [ echo $line ]
  echo (enthavesel) entities selected
]

enttoggle  = [ entmoving 1; entmoving 0; ]
entaddmove = [ entmoving 2 ]

grabbing = 0

drag       = [ dragging 1; onrelease [ dragging 0 ] ]
corners    = [ selectcorners 1; dragging 1; onrelease [ selectcorners 0; dragging 0 ] ]
entadd     = [ entaddmove; entmoving 0; ]
editmove   = [ moving 1; onrelease [ moving 0 ]; result $moving ]
entdrag    = [ entaddmove; onrelease [ finish_dragging; entmoving 0]; result $entmoving ] // INTENSITY: Added finish_dragging
editdrag   = [ cancelsel; || (entdrag) [ drag ] ]
selcorners = [ if ($hmapedit) [ hmapselect ] [ cancelsel; || (entdrag) [ corners ] ] ]
editextend = [ || entdrag [ selextend; reorient; editmove ] ]

editmovewith    = [
  if (havesel) [
    || (editmove) [ @arg1 ]
    onrelease [ moving 0; dragging 0 ]
  ] [
    @arg1
  ]
]

editmovecorner = [ editmovewith selcorners ]
editmovedrag   = [ editmovewith editdrag ]

////// Other Editing commands /////////

editfacewentpush = [ 
  
  if (|| [havesel] [! (enthavesel)] ) [
    if ($moving) [ 
      pushsel $arg1 
    ] [ 
      entcancel
      editface $arg1 $arg2
    ] 
  ] [
      if ($entmoving) [ entpush $arg1 ] [ ent_action_@(et) ]
  ]
]

entswithdirection = "playerstart teledest mapmodel monster box barrel platform elevator"

inlist = [
  r = 0
  n = ( listlen $arg2 )
  loop i $n [
    if (strcmp $arg1 (at $arg2 $i)) [
      r = 1 
    ]
  ]
  result $r
]

entdirection = [
  if ( && (enthavesel) [ = (havesel) 0 ] ) [
    if (inlist (et) $entswithdirection) [
      if (> $arg1 0) [
        entproperty 0 @@arg2
        if (> (ea 0) 360) [ entproperty 0 -360 ]          
      ] [
        entproperty 0 -@@arg2
        if (< (ea 0) 0) [ entproperty 0 360 ]
      ]
    ]
    result 1
  ] [
    result 0
  ]
]

editdel    = [ if (! (enthavesel)) [delcube]; delent ]
editflip   = [ flip; entflip ]

editrotate = [ 
  || [ entdirection $arg1 15 ] [ 
      rotate $arg1
      entrotate $arg1 
    ] 
]

editcut    = [  
  hadselection = (havesel)
  moving 1
  if ($moving) [
    copy;     entcopy
    delcube;  delent
    onrelease [ 
      moving 0
      paste
      entpaste
      if ( ! $hadselection ) [ cancelsel ]
    ]
  ]
]

passthrough = [ 
  passthroughsel $arg1; 
  if ($arg1) [
    passthroughcube_bak = $passthroughcube
    passthroughcube 1
  ] [
    passthroughcube $passthroughcube_bak
  ]
  entcancel 
  if ( setting_entediting ) [ entediting ( ! $arg1 ) ]
  
]

edithud = [
    if (enthavesel) [concatword (entget) " : " (enthavesel) " selected"]
]

listcomplete editmat "air water clip glass noclip lava gameclip death alpha"
air = [ editmat air ]
water = [ editmat water ]
clip = [ editmat clip ]
glass = [ editmat glass ]
noclip = [ editmat noclip ]
lava = [ editmat lava ]
gameclip = [ editmat gameclip ]
death = [ editmat death ]
alpha = [ editmat alpha ]

blendpaintmodes = ["off" "replace" "dig" "fill" "inverted dig" "inverted fill"]
setblendpaintmode = [
    if (> $numargs 0) [blendpaintmode $arg1] [blendpaintmode 0]
    echo "blend paint mode set to:" (at $blendpaintmodes $blendpaintmode)
]
scrollblendbrush = [
    if (> $numargs 0) [nextblendbrush $arg1] [nextblendbrush]
    echo "blend brush set to:" (getblendbrushname (curblendbrush))
]


// INTENSITY
exec "data/intensity_edit.cfg"

minimaphere = [minimapheight (at (getcampos) 2)]
]])
