extensions [ rnd csv nw ]

breed [ workers worker ]
breed [ capitalists capitalist ]

workers-own [ class unemployed opinion weight experimental-evidence culture soc cc unem lob- lob+ old-opinion link-degree] ; weight included
capitalists-own [ interest relative-power lobby-opinion ]

globals [
test-list

  population

  green-capacity-list
  unemployment-list
  change-in-unemployment-list
  anomaly-real-list
  anomaly-shiftingBL-list
    real-wage-growth-list

  anomaly-list

  anomaly-real
  anomaly-shiftingBL
  anomaly

  share-green-capacity-DSK
  change-in-unemployment
  unemployment
  real-wage-growth
  avg-real-wage-growth-past


  current-unemployment

  count-median-opinion-3
  count-median-opinion-2
  count-median-opinion-1

  modal-opinion
  list-of-share-of-supporters-empirical
  list-of-share-of-opponents-empirical
  list-of-share-of-neutrals-empirical

  share-supporters-empirical
  share-opponents-empirical
  share-neutrals-empirical

  list-of-median-opinion
  list-of-share-of-supporters
  list-of-share-of-opponents
  list-of-share-of-neutrals

  list-of-losses-supporters
  list-of-losses-neutrals
  list-of-losses-opponents

  share-of-years-with-median-opinion-support

  share-of-policy-acceptants
  share-of-policy-supporters
  share-of-policy-neutrals
  share-of-policy-opponents

  count-1to2
  sum-soc-1to2
  sum-cc-1to2
  sum-unem-1to2
  sum-lob--1to2
  sum-lob+-1to2

  count-2to3
  sum-soc-2to3
  sum-cc-2to3
  sum-unem-2to3
  sum-lob--2to3
  sum-lob+-2to3

  count-3to2
  sum-soc-3to2
  sum-cc-3to2
  sum-unem-3to2
  sum-lob--3to2
  sum-lob+-3to2

  count-2to1
  sum-soc-2to1
  sum-cc-2to1
  sum-unem-2to1
  sum-lob--2to1
  sum-lob+-2to1


  cumulative-support
  cumulative-opponents
  cumulative-neutrals

  share-of-years-median-3
  share-of-years-median-2
  share-of-years-median-1

  used-seed-parameter

  share_1_0_1
  share_1_0_2
  share_1_0_3
  share_1_1_1
  share_1_1_2
  share_1_1_3
  share_2_0_1
  share_2_0_2
  share_2_0_3
  share_2_1_1
  share_2_1_2
  share_2_1_3
  share_3_0_1
  share_3_0_2
  share_3_0_3
  share_3_1_1
  share_3_1_2
  share_3_1_3
  share_4_0_1
  share_4_0_2
  share_4_0_3
  share_4_1_1
  share_4_1_2
  share_4_1_3
  share_5_0_1
  share_5_0_2
  share_5_0_3
  share_5_1_1
  share_5_1_2
  share_5_1_3

  country-fe

  national-weight ;
]

to setup
  ca
  set-default-shape workers "person"
  set-default-shape capitalists "star"
;  random-seed 2
  create-capitalists 1 [
    set color 62
    set size 3
    set interest "renewables"
    set lobby-opinion 3
    set relative-power share-green-capacity-DSK
    fd 2
  ]

   create-capitalists 1 [
    set color 32
    set size 3
    set interest "fossils"
    set lobby-opinion 1
    set relative-power 1 - share-green-capacity-DSK
    fd 4
  ]

  file-close-all
  ifelse DSK-data
  [
    ifelse opinion-initialization-new
    [file-open "workers_details19_w_new.csv"] ; alternative opinion definition
    [file-open "workers_details19_w.csv"]  ; original opinion definition
  ]
  [
    ifelse opinion-initialization-new
    [file-open "workers_details_w_new.csv"]
    [file-open "workers_details_w.csv"]
  ]


  let headings csv:from-row file-read-line

  while [ not file-at-end? ] [
    let data csv:from-row file-read-line
    if item 0 data = country [
      create-workers item 4 data [
        set unemployed item 1 data
        set class item 2 data
        set opinion item 3 data
        set old-opinion opinion
        set weight item 5 data
      ]
    ]
  ]
  file-close-all

  ask workers [
    update-culture
  ]

  update-color

  set national-weight sum [weight] of workers

  layout-circle workers 15

  if network = "homophilic"
  [
    generate-network (average-degree / 2)
  ]

  if network = "configuration"
  [
    generate-configuration-network (average-degree / 2)
  ]

  if network = "random"
  [
    generate-random-network average-degree / count workers
  ]


  set list-of-median-opinion ( list median [opinion] of workers )
  set list-of-share-of-supporters ( list share-of-supporters )
  set list-of-share-of-opponents ( list share-of-opponents )
  set list-of-share-of-neutrals ( list share-of-neutrals )


  ifelse DSK-data
  [
    file-open scenario
    let headings1 csv:from-row file-read-line
    while [ not file-at-end? ] [
      let data csv:from-row file-read-line
      if item 0 data = "change_in_unem" [
        set change-in-unemployment-list remove-item 0 data
      ]
      if item 0 data = "real_wage_growth" [
        set real-wage-growth-list remove-item 0 data
      ]
      if item 0 data = "gCap_share" [
        set green-capacity-list remove-item 0 data
      ]
      if item 0 data = "anomaly_real" [
        set anomaly-real-list remove-item 0 data
      ]
      if item 0 data = "anomaly_shiftingBL" [
        set anomaly-shiftingBL-list remove-item 0 data
      ]
    ]

  file-close-all
  ]
  [

    file-open "green_capacity_calibration.csv"
     let headings1 csv:from-row file-read-line
    while [ not file-at-end? ] [
      let data csv:from-row file-read-line
      if item 0 data = country [
        set green-capacity-list remove-item 0 data
      ]
    ]
     file-close-all
    file-open "unemployment_calibration.csv"

    let headings2 csv:from-row file-read-line

    while [ not file-at-end? ] [
      let data csv:from-row file-read-line
      if item 0 data = country [
        set unemployment-list remove-item 0 data
      ]
    ]
    file-close-all
     file-open "anomaly_calibration.csv"

  let headings3 csv:from-row file-read-line

  while [ not file-at-end? ] [
    let data csv:from-row file-read-line
    if item 0 data = country [
      set anomaly-real-list remove-item 0 data
    ]
  ]
  file-close-all
    file-open "anomaly_shiftingBL_calibration.csv"

  let headings3a csv:from-row file-read-line

  while [ not file-at-end? ] [
    let data csv:from-row file-read-line
    if item 0 data = country [
      set anomaly-shiftingBL-list remove-item 0 data
    ]
  ]
  file-close-all
  ]


  set share-green-capacity-DSK ( item 0 green-capacity-list )
  update-relative-power-of-lobbyists


  set current-unemployment calculate-current-unemployment ; unemployment calculated from representative heterogeneous agents in the  model
  set unemployment current-unemployment


  set anomaly-real item 0 anomaly-real-list


  set anomaly-shiftingBL (item 0 anomaly-shiftingBL-list )

  ifelse shifting-baseline = "off" [
    set anomaly-list anomaly-real-list ] [
    set anomaly-list anomaly-shiftingBL-list ]
  set anomaly item 0 anomaly-list


  file-open "supporters_calibration_w.csv"

  let headings5 csv:from-row file-read-line

  while [ not file-at-end? ] [
    let data csv:from-row file-read-line
    if item 0 data = country [
      set list-of-share-of-supporters-empirical remove-item 0 data
    ]
  ]
  file-close-all

  file-open "neutrals_calibration_w.csv"

  let headings6 csv:from-row file-read-line

  while [ not file-at-end? ] [
    let data csv:from-row file-read-line
    if item 0 data = country [
      set list-of-share-of-neutrals-empirical remove-item 0 data
    ]
  ]
  file-close-all

  file-open "opponents_calibration_w.csv"

  let headings7 csv:from-row file-read-line

  while [ not file-at-end? ] [
    let data csv:from-row file-read-line
    if item 0 data = country [
      set list-of-share-of-opponents-empirical remove-item 0 data
    ]
  ]
  file-close-all

  set share-of-policy-acceptants share-of-acceptants

  set list-of-share-of-supporters ( list share-of-supporters )
  set list-of-share-of-opponents ( list share-of-opponents )
  set list-of-share-of-neutrals ( list share-of-neutrals )

  set share-supporters-empirical ( item 0 list-of-share-of-supporters-empirical )
  set share-opponents-empirical ( item 0 list-of-share-of-opponents-empirical )
  set share-neutrals-empirical (item 0 list-of-share-of-neutrals-empirical )


  set population count workers
  reset-ticks
end

to update-relative-power-of-lobbyists
  ask capitalists with [interest = "renewables"] [
    set relative-power share-green-capacity-DSK
  ]

  ask capitalists with [ interest = "fossils" ] [
    set relative-power 1 - share-green-capacity-DSK
  ]
end


to update-culture
  let trait1 [unemployed] of self / 2
  let trait2 [opinion] of self / 3
  let trait3 [class] of self / 5
  set culture (list trait1 trait2 trait3 )
end

to update-color
  ask workers with [ opinion = 3 ] [
    set color green ]
  ask workers with [ opinion = 2 ] [
    set color white ]
  ask workers with [ opinion = 1 ] [
    set color red ]
end

to generate-network [ number-links ]
  run (word "ask workers [ create-links" "-with rnd:weighted-n-of " number-links " other workers [cultural-similarity  self myself ]]")
end

to generate-configuration-network [ number-links ]
  run (word "ask workers [ create-links" "-with rnd:weighted-n-of " number-links " other workers [cultural-similarity  self myself ]]")
  ask workers
  [
    set link-degree count my-links
  ]
  ask links
  [
    die
  ]
  let workers-to-be-linked workers
  while [count workers-to-be-linked > 1]
  [
    ask one-of workers-to-be-linked
    [
      let link-target one-of other workers-to-be-linked who-are-not link-neighbors
      ifelse is-worker? link-target
      [
        create-link-with link-target
        if count my-links >= link-degree
        [
          set workers-to-be-linked other workers-to-be-linked
        ]
        ask link-target
        [
          if count my-links >= link-degree
          [
            set workers-to-be-linked other workers-to-be-linked
          ]
        ]
      ]
      [
        set workers-to-be-linked other workers-to-be-linked
      ]
    ]
  ]
  if count workers-to-be-linked = 1
  [
    ask one-of workers-to-be-linked
    [
      if count my-links = 0
      [
        create-link-with one-of other workers
      ]
    ]
  ]
end


to generate-random-network [ probability-rnw ]

  let workers-to-be-linked workers
  ask workers
  [
    ask other workers-to-be-linked
    [
      if random-float 1 < probability-rnw
      [
        create-link-with myself
      ]
    ]
    if count my-links = 0
    [
      create-link-with one-of other workers
    ]
    set workers-to-be-linked other workers-to-be-linked
  ]
end



to go
  set modal-opinion first modes [opinion] of workers
  ifelse DSK-data
  [
    if ticks = 31 [stop]
  ]
  [
    if ticks = 8 [stop]
  ]
  update-from-DSK
  social-influence
  exogenous-influence
  update-opinion
  update-statistics
  tick
end


to update-from-DSK
  set share-green-capacity-DSK item ( ticks + 1 ) green-capacity-list
  update-relative-power-of-lobbyists
  ifelse DSK-data
  [
    set change-in-unemployment item ( ticks + 1 ) change-in-unemployment-list
  ]
  [
    set unemployment item ( ticks + 1 ) unemployment-list
  ]
  if DSK-data
  [
    set real-wage-growth item ( ticks + 1 ) real-wage-growth-list
    if ticks > 3  [
    set avg-real-wage-growth-past mean sublist real-wage-growth-list (ticks - 3) ticks ]
  ]
  set anomaly item ( ticks + 1 ) anomaly-list
  set anomaly-shiftingBL item ( ticks + 1 ) anomaly-shiftingBL-list
  update-unemployed
end


to update-unemployed
  employee-turnover ; rate at which employees leave a company and are replaced by new employees
  job-turnover ; net change in employment
  set current-unemployment calculate-current-unemployment
end

to employee-turnover
  let abs-turnover-lower-class turnover * ( count workers with [ unemployed = 0 and ( class = 1 or class = 2 ) ] )
  let abs-turnover-middle-class turnover * ( count workers with [ unemployed = 0 and ( class = 3 or class = 4 ) ] )
  let abs-turnover-upper-class turnover * ( count workers with [ unemployed = 0 and ( class = 5 ) ] )

  ask n-of abs-turnover-lower-class workers with [ unemployed = 0 and ( class = 1 or class = 2 ) ] [
    set unemployed 1
    update-culture ]
  ask n-of abs-turnover-lower-class workers with [ unemployed = 1 and ( class = 1 or class = 2 ) ] [
    set unemployed 0
    update-culture ]

  ask n-of abs-turnover-middle-class workers with [ unemployed = 0 and ( class = 3 or class = 4 ) ] [
    set unemployed 1
    update-culture ]
  ask n-of abs-turnover-middle-class workers with [ unemployed = 1 and ( class = 3 or class = 4 ) ] [
    set unemployed 0
    update-culture ]

  ask n-of abs-turnover-upper-class workers with [unemployed = 0 and ( class = 5 ) ] [
    set unemployed 1
    update-culture ]
  ask n-of abs-turnover-upper-class workers with [ unemployed = 1 and ( class = 5 ) ] [
    set unemployed 0
    update-culture ]
end


to job-turnover
  let diff 0
  ifelse DSK-data
  [
    set diff change-in-unemployment
  ]
  [
    set diff unemployment - current-unemployment
  ]
  ifelse diff >= 0 [
    ask n-of ( diff * count workers ) workers with [ unemployed = 0 ] [
      set unemployed 1
      update-culture ]
  ]
  [
    ask n-of min ( list  ( abs diff * count workers ) ( count workers with [ unemployed = 1 ]) ) workers with [ unemployed = 1 ] [
      set unemployed 0
      update-culture ]
  ]
end

to-report calculate-current-unemployment
  report count workers with [unemployed = 1] / count workers
end

to social-influence
  ask workers [
    let neighbor one-of link-neighbors
    ifelse [ opinion ] of neighbor = [ opinion ] of self [ set soc 0 ]
    [
      if [ opinion ] of neighbor > [ opinion ] of self [ set soc persuasive-force ]
      if [ opinion ] of neighbor < [ opinion ] of self [ set soc (-1) * persuasive-force ]
    ]
  ]
end

to exogenous-influence
  ask workers
  [
    if opinion = 2 [
      set experimental-evidence anomaly
    ]
    ifelse anomaly > 0
    [
      if opinion = 1 [
        set experimental-evidence (1 - biased-assimilation) * anomaly
      ]
      if opinion = 3 [
        set experimental-evidence (1 + biased-assimilation) * anomaly
      ]
    ]
    [
      if opinion = 1 [
        set experimental-evidence (1 + biased-assimilation) * anomaly
      ]
      if opinion = 3 [
        set experimental-evidence (1 - biased-assimilation) * anomaly
      ]
    ]
    set cc evidence-effectiveness * experimental-evidence

    ifelse unemployed = 1
    [
      set unem unemployment-effect
    ]
    [
      set unem 0
    ]
    set lob- 0
    set lob+ 0
  ]
  ask capitalists with [ interest = "fossils" ] [
    ask n-of (share-of-targeted-workers * relative-power * count workers) workers [
      set lob- (-1) * lobbying-effect
       ]
  ]
  ask capitalists with [interest = "renewables" ] [
    ask n-of (share-of-targeted-workers * relative-power * count workers) workers [
      set lob+ lobbying-effect
       ]
  ]
end

to update-opinion
  ask workers [
    set old-opinion opinion
    let decision soc + cc + unem + lob- + lob+
    if opinion = modal-opinion
    [
      set decision decision * (1 - sluggishness)
    ]
    ifelse decision >= 0
    [if opinion < 3 and random-float 1 < decision [ set opinion opinion + 1 ] ]
    [if opinion > 1 and random-float 1 < abs decision [ set opinion opinion - 1 ] ]
    update-culture
  ]
  update-color
end


to-report cultural-similarity [ worker-a worker-b ]
  let culture-a [ culture ] of worker-a
  let culture-b [ culture ] of worker-b
  report mean (map [ [ trait-a trait-b ] -> 1 - abs ((trait-a - trait-b)) ] culture-a culture-b)
end



to update-statistics
  set list-of-median-opinion lput ( median [opinion] of workers ) list-of-median-opinion


  set count-1to2 count workers with [old-opinion = 1 and opinion = 2]
  set sum-soc-1to2 sum [soc] of workers with [old-opinion = 1 and opinion = 2]
  set sum-cc-1to2 sum [cc] of workers with [old-opinion = 1 and opinion = 2]
  set sum-unem-1to2 sum [unem] of workers with [old-opinion = 1 and opinion = 2]
  set sum-lob--1to2 sum [lob-] of workers with [old-opinion = 1 and opinion = 2]
  set sum-lob+-1to2 sum [lob+] of workers with [old-opinion = 1 and opinion = 2]

  set count-3to2 count workers with [old-opinion = 3 and opinion = 2]
  set sum-soc-3to2 sum [soc] of workers with [old-opinion = 3 and opinion = 2]
  set sum-cc-3to2 sum [cc] of workers with [old-opinion = 3 and opinion = 2]
  set sum-unem-3to2 sum [unem] of workers with [old-opinion = 3 and opinion = 2]
  set sum-lob--3to2 sum [lob-] of workers with [old-opinion = 3 and opinion = 2]
  set sum-lob+-3to2 sum [lob+] of workers with [old-opinion = 3 and opinion = 2]

  set count-2to1 count workers with [old-opinion = 2 and opinion = 1]
  set sum-soc-2to1 sum [soc] of workers with [old-opinion = 2 and opinion = 1]
  set sum-cc-2to1 sum [cc] of workers with [old-opinion = 2 and opinion = 1]
  set sum-unem-2to1 sum [unem] of workers with [old-opinion = 2 and opinion = 1]
  set sum-lob--2to1 sum [lob-] of workers with [old-opinion = 2 and opinion = 1]
  set sum-lob+-2to1 sum [lob+] of workers with [old-opinion = 2 and opinion = 1]

  set count-2to3 count workers with [old-opinion = 2 and opinion = 3]
  set sum-soc-2to3 sum [soc] of workers with [old-opinion = 2 and opinion = 3]
  set sum-cc-2to3 sum [cc] of workers with [old-opinion = 2 and opinion = 3]
  set sum-unem-2to3 sum [unem] of workers with [old-opinion = 2 and opinion = 3]
  set sum-lob--2to3 sum [lob-] of workers with [old-opinion = 2 and opinion = 3]
  set sum-lob+-2to3 sum [lob+] of workers with [old-opinion = 2 and opinion = 3]

  set share-of-policy-acceptants share-of-acceptants
  set share-of-policy-supporters share-of-supporters
  set share-of-policy-neutrals share-of-neutrals
  set share-of-policy-opponents share-of-opponents

  set list-of-share-of-supporters lput share-of-policy-supporters list-of-share-of-supporters
  set list-of-share-of-neutrals lput share-of-policy-neutrals list-of-share-of-neutrals
  set list-of-share-of-opponents lput share-of-policy-opponents list-of-share-of-opponents


  set cumulative-support sum list-of-share-of-supporters
  set cumulative-opponents sum list-of-share-of-opponents
  set cumulative-neutrals sum list-of-share-of-neutrals

  update-median-opinion-shares current-median-opinion

  set share-of-years-median-3 share-of-years-with-median-opinion-3
  set share-of-years-median-2 share-of-years-with-median-opinion-2
  set share-of-years-median-1 share-of-years-with-median-opinion-1

  if DSK-data = false
  [
    set share-supporters-empirical item (ticks + 1) list-of-share-of-supporters-empirical
    set share-opponents-empirical item (ticks + 1) list-of-share-of-opponents-empirical
    set share-neutrals-empirical item (ticks + 1) list-of-share-of-neutrals-empirical
  ]

set share_1_0_1 count workers with [class = 1 and unemployed = 0 and opinion = 1] / count workers
set share_1_0_2 count workers with [class = 1 and unemployed = 0 and opinion = 2] / count workers
set share_1_0_3 count workers with [class = 1 and unemployed = 0 and opinion = 3] / count workers
set share_1_1_1 count workers with [class = 1 and unemployed = 1 and opinion = 1] / count workers
set share_1_1_2 count workers with [class = 1 and unemployed = 1 and opinion = 2] / count workers
set share_1_1_3 count workers with [class = 1 and unemployed = 1 and opinion = 3] / count workers
set share_2_0_1 count workers with [class = 2 and unemployed = 0 and opinion = 1] / count workers
set share_2_0_2 count workers with [class = 2 and unemployed = 0 and opinion = 2] / count workers
set share_2_0_3 count workers with [class = 2 and unemployed = 0 and opinion = 3] / count workers
set share_2_1_1 count workers with [class = 2 and unemployed = 1 and opinion = 1] / count workers
set share_2_1_2 count workers with [class = 2 and unemployed = 1 and opinion = 2] / count workers
set share_2_1_3 count workers with [class = 2 and unemployed = 1 and opinion = 3] / count workers
set share_3_0_1 count workers with [class = 3 and unemployed = 0 and opinion = 1] / count workers
set share_3_0_2 count workers with [class = 3 and unemployed = 0 and opinion = 2] / count workers
set share_3_0_3 count workers with [class = 3 and unemployed = 0 and opinion = 3] / count workers
set share_3_1_1 count workers with [class = 3 and unemployed = 1 and opinion = 1] / count workers
set share_3_1_2 count workers with [class = 3 and unemployed = 1 and opinion = 2] / count workers
set share_3_1_3 count workers with [class = 3 and unemployed = 1 and opinion = 3] / count workers
set share_4_0_1 count workers with [class = 4 and unemployed = 0 and opinion = 1] / count workers
set share_4_0_2 count workers with [class = 4 and unemployed = 0 and opinion = 2] / count workers
set share_4_0_3 count workers with [class = 4 and unemployed = 0 and opinion = 3] / count workers
set share_4_1_1 count workers with [class = 4 and unemployed = 1 and opinion = 1] / count workers
set share_4_1_2 count workers with [class = 4 and unemployed = 1 and opinion = 2] / count workers
set share_4_1_3 count workers with [class = 4 and unemployed = 1 and opinion = 3] / count workers
set share_5_0_1 count workers with [class = 5 and unemployed = 0 and opinion = 1] / count workers
set share_5_0_2 count workers with [class = 5 and unemployed = 0 and opinion = 2] / count workers
set share_5_0_3 count workers with [class = 5 and unemployed = 0 and opinion = 3] / count workers
set share_5_1_1 count workers with [class = 5 and unemployed = 1 and opinion = 1] / count workers
set share_5_1_2 count workers with [class = 5 and unemployed = 1 and opinion = 2] / count workers
set share_5_1_3 count workers with [class = 5 and unemployed = 1 and opinion = 3] / count workers

end

to-report shorten-list [ long-list]
  let result []
  foreach long-list [ x -> if (position x long-list mod 2 = 0) [ set result lput x result ] ]
  report result
end

to-report current-median-opinion
   report median [opinion] of workers
end

to-report share-of-supporters
  report ( count workers with [ opinion = 3] ) / ( count workers )
end

to-report share-of-neutrals
  report ( count workers with [ opinion = 2] ) / ( count workers )
end

to-report share-of-opponents
  report ( count workers with [ opinion = 1] ) / ( count workers )
end

to-report share-of-acceptants
  report ( count workers with [ opinion = 3 or opinion = 2] ) / ( count workers )
end

to-report loss-supporters
  report (share-of-supporters - share-supporters-empirical) ^ 2
end

to-report loss-opponents
  report (share-of-opponents - share-opponents-empirical) ^ 2
end

to-report loss-neutrals
  report (share-of-neutrals - share-neutrals-empirical) ^ 2
end

to update-median-opinion-shares [current-median]
  if current-median = 3 [
    set count-median-opinion-3 count-median-opinion-3 + 1
  ]
  if current-median = 2 [
    set count-median-opinion-2 count-median-opinion-2 + 1
  ]
  if current-median = 1 [
    set count-median-opinion-1 count-median-opinion-1 + 1 ]

end

to-report share-of-years-with-median-opinion-3
  if length list-of-median-opinion = 0 [
    report 0
  ]
  report count-median-opinion-3 / ( length list-of-median-opinion - 1)
end

to-report share-of-years-with-median-opinion-2
  if length list-of-median-opinion = 0 [
    report 0
  ]
  report count-median-opinion-2 / ( length list-of-median-opinion - 1)
end

to-report share-of-years-with-median-opinion-1
  if length list-of-median-opinion = 0 [
    report 0
  ]
  report count-median-opinion-1 / ( length list-of-median-opinion - 1)
end



to-report frequency [an-item a-list]
    report length (filter [ i -> i = an-item] a-list)
end

to-report loss-list [first-list second-list]
  report ( map [ [ a b ] -> ( a - b ) ^ 2 ] first-list second-list )
end
@#$#@#$#@
GRAPHICS-WINDOW
413
10
850
448
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
7
124
70
157
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
7
161
70
194
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
73
162
148
195
go once
go 
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
209
184
242
persuasive-force
persuasive-force
0
1
0.2
0.1
1
NIL
HORIZONTAL

PLOT
1239
61
1618
303
Distribution of policy opinion over time
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"supporters" 1.0 0 -10899396 true "" "plot count workers with [ opinion = 3 ]"
"neutrals" 1.0 0 -7500403 true "" "plot count workers with [ opinion = 2 ]"
"opponents" 1.0 0 -2674135 true "" "plot count workers with [ opinion = 1 ]"

SLIDER
7
285
179
318
biased-assimilation
biased-assimilation
0
1
0.0
.05
1
NIL
HORIZONTAL

SLIDER
7
327
181
360
evidence-effectiveness
evidence-effectiveness
0
0.5
0.48
.01
1
NIL
HORIZONTAL

TEXTBOX
56
387
206
405
NIL
11
0.0
1

SLIDER
8
369
180
402
unemployment-effect
unemployment-effect
0
1
0.22
0.01
1
NIL
HORIZONTAL

PLOT
1239
302
1618
546
public policy support
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"policy support" 1.0 0 -16777216 true "" "plot share-of-policy-supporters"
"50 % threshold" 1.0 0 -13840069 true "" "plot 0.5"
"policy acceptance" 1.0 0 -7500403 true "" "plot share-of-policy-acceptants"

SLIDER
8
406
181
439
share-of-targeted-workers
share-of-targeted-workers
0
1
1.0
.1
1
NIL
HORIZONTAL

SLIDER
8
443
180
476
lobbying-effect
lobbying-effect
0
1
0.33
.01
1
NIL
HORIZONTAL

INPUTBOX
19
550
174
610
turnover
0.07
1
0
Number

PLOT
912
448
1214
609
unemployment check
NIL
NIL
0.0
10.0
0.0
0.3
true
true
"" ""
PENS
"unemployment DSK" 1.0 0 -14439633 true "" "plot unemployment"
"unemployment OD" 1.0 0 -7500403 true "" "plot current-unemployment"

MONITOR
895
186
1038
231
lower class unemployed
count workers with [unemployed = 1 and ( class = 1 or class = 2 ) ] / count workers with [unemployed = 1]
17
1
11

MONITOR
911
271
1192
316
NIL
evidence-effectiveness * anomaly
17
1
11

PLOT
686
454
886
604
distribution of policy opinion
NIL
NIL
0.0
5.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [opinion] of workers"

CHOOSER
5
75
143
120
shifting-baseline
shifting-baseline
"on" "off"
0

INPUTBOX
5
10
236
70
country
AT
1
0
String

MONITOR
886
28
982
73
loss opponents
sum loss-list list-of-share-of-opponents list-of-share-of-opponents-empirical
17
1
11

MONITOR
889
76
986
121
loss supporters
sum loss-list list-of-share-of-supporters list-of-share-of-supporters-empirical
17
1
11

PLOT
360
639
560
789
share of supporters
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"simulated" 1.0 0 -16777216 true "" "plot share-of-supporters"
"empirical" 1.0 0 -14439633 true "" "plot share-supporters-empirical"

PLOT
158
639
358
789
share opponents
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"simulated" 1.0 0 -16777216 true "" "plot share-of-opponents"
"empirical" 1.0 0 -5298144 true "" "plot share-opponents-empirical"

PLOT
604
647
804
797
share of neutrals
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"empirical" 1.0 0 -13791810 true "" "plot share-neutrals-empirical"
"simulated" 1.0 0 -16777216 true "" "plot share-of-neutrals"

INPUTBOX
299
558
454
618
random-seed-max
1000.0
1
0
Number

INPUTBOX
301
492
456
552
random-seed-fixed
1.0
1
0
Number

SLIDER
9
248
181
281
sluggishness
sluggishness
0
1
0.5
0.01
1
NIL
HORIZONTAL

INPUTBOX
243
10
543
70
scenario
emissG_1_0065.csv
1
0
String

SWITCH
283
110
393
143
DSK-data
DSK-data
0
1
-1000

TEXTBOX
284
95
434
113
Calibration period: Off
11
0.0
1

SWITCH
206
164
396
197
opinion-initialization-new
opinion-initialization-new
0
1
-1000

TEXTBOX
225
149
375
167
Initially submitted version: Off
11
0.0
1

CHOOSER
200
260
338
305
network
network
"homophilic" "random" "configuration"
0

SLIDER
202
308
374
341
average-degree
average-degree
1
8
4.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

In this version, there is a decision variable which adds all the effects soc, unem, cc, lob+ and lob-. 
For calibration, the question remains whether we should include biased assimilation and whether we should try to endogenize value of persuasive-force instead of setting it exogenously. In this file, we chose to determine persuasive-force endogenously and set biased assimilation 0.

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
