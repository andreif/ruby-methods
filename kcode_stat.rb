#require '/Users/andrei/Workspace/Environment/Programming/Library/Ruby/methods/nps_stat.rb'
require :time
$nps_stat_details = !true
def nps_stat_print curr_time, prev_time, curr_nps, prev_nps, tasks = nil
  dt = curr_time - prev_time
  puts "%s-%s = %2d:%02d:%02d, %5s-%-5s = %5s,  %.0f n/sec, %.0f n/sec/task" % [
    prev_time.strftime('%H:%M:%S'), 
    curr_time.strftime('%H:%M:%S'),
    dt/3600, dt%3600/60, dt%600%60,
    prev_nps.zero? ? nil : curr_nps,
    prev_nps.zero? ? nil : prev_nps,
    dn = curr_nps - prev_nps,
    r = dn/dt,
    r/tasks
  ]
end
def nps_stat log
  prev_nps = 0; start_nps = start_time = prev_time = curr_time = curr_nps = nil
  puts '='*105 if $nps_stat_details
  puts (tasks = log.scan(/master starting\s+(\d+)(.+)$/).flatten).join.gsub(/  +/,' ') rescue nil
  tasks = tasks.first.to_i
  tasks += 1 if log =~ /rendezvous at/ # mcnpx correction
  puts '-'*105 if $nps_stat_details
  log.scan(/(master set )?rendezvous( at)? nps =\s+(\d+)\s+(# of microtasks =\s+\d+)?(.*)$/).each do |s|
    next_nps = s[2].to_i
    curr_time = Time.parse s.last.gsub(/(\d+)(\/\d+)(\/\d+)/,'\\1\\3\\2')
    if start_time
      nps_stat_print curr_time, prev_time, curr_nps, prev_nps, tasks if $nps_stat_details
      prev_nps = curr_nps
    end
    start_nps ||= next_nps
    start_time ||= curr_time
    prev_time = curr_time
    curr_nps = next_nps
  end
  puts '-'*105 if $nps_stat_details
  nps_stat_print curr_time, start_time, prev_nps, start_nps, tasks
  puts "\n"
end


nps_stat "
master starting       2 by       1 subtasks   10/03/10 17:26:02   2000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =     24228       10/03/10 17:27:29
    12   0.97317       11.06        2    0.97040    0.00276      40133
master set rendezvous nps =     26247       10/03/10 17:27:36
    13   0.97075       12.79        3    0.97052    0.00160      76658
master set rendezvous nps =     28201       10/03/10 17:27:44
    14   0.96726       14.63        4    0.96970    0.00139      72811
master set rendezvous nps =     30200       10/03/10 17:27:52
    15   0.97718       16.59        5    0.97120    0.00185      32218
master set rendezvous nps =     32205       10/03/10 17:27:59
    16   0.95453       18.66        6    0.96842    0.00316       8796
master set rendezvous nps =     34103       10/03/10 17:28:07
    17   0.97778       20.86        7    0.96976    0.00299       8188
master set rendezvous nps =     36220       10/03/10 17:28:15
    18   0.97161       23.18        8    0.96999    0.00260       9177
master set rendezvous nps =     38185       10/03/10 17:28:23
    19   0.97799       25.63        9    0.97088    0.00246       8849
master set rendezvous nps =     40268       10/03/10 17:28:31
    20   0.97284       28.21       10    0.97108    0.00221       9578
master set rendezvous nps =     42242       10/03/10 17:28:39
    21   0.95532       30.90       11    0.96964    0.00246       6800
master set rendezvous nps =     44196       10/03/10 17:28:46
    22   0.98482       33.70       12    0.97091    0.00257       5531
master set rendezvous nps =     46249       10/03/10 17:28:54
    23   0.96160       36.63       13    0.97019    0.00247       5368
master set rendezvous nps =     48211       10/03/10 17:29:02
    24   0.95075       39.69       14    0.96880    0.00268       4126
master set rendezvous nps =     50184       10/03/10 17:29:10
    25   0.96071       42.86       15    0.96826    0.00255       4129
master set rendezvous nps =     52131       10/03/10 17:29:17
    26   1.00088       46.16       16    0.97030    0.00314       2504
master set rendezvous nps =     54225       10/03/10 17:29:25
    27   0.99539       49.60       17    0.97178    0.00330       2088
master set rendezvous nps =     56205       10/03/10 17:29:34
    28   0.98994       53.15       18    0.97279    0.00327       1962
master set rendezvous nps =     58205       10/03/10 17:29:41
    29   0.96947       56.83       19    0.97261    0.00310       2020
master set rendezvous nps =     60149       10/03/10 17:29:49
    30   0.97930       60.63       20    0.97295    0.00296       2058
master set rendezvous nps =     62132       10/03/10 17:29:57
    31   0.96922       64.56       21    0.97277    0.00282       2107
master set rendezvous nps =     64130       10/03/10 17:30:05
    32   0.95747       68.61       22    0.97207    0.00278       2024
master set rendezvous nps =     66063       10/03/10 17:30:13
"

nps_stat "
master starting       2 by       1 subtasks   10/03/10 17:50:28   10000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 17:50:29
master set rendezvous nps =     10000       10/03/10 17:50:30

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.65590        1.11
master set rendezvous nps =     16763       10/03/10 17:51:02
     2   0.92812        2.49
master set rendezvous nps =     30972       10/03/10 17:51:27
     3   0.95567        4.97
master set rendezvous nps =     41339       10/03/10 17:52:14
     4   0.96221        7.94
master set rendezvous nps =     51442       10/03/10 17:52:51
     5   0.96315       11.50
master set rendezvous nps =     61462       10/03/10 17:53:29
     6   0.97242       15.69
master set rendezvous nps =     71564       10/03/10 17:54:07
     7   0.96930       20.48
master set rendezvous nps =     81327       10/03/10 17:54:45
     8   0.97291       25.85
master set rendezvous nps =     91351       10/03/10 17:55:21
     9   0.98733       31.88
master set rendezvous nps =    101598       10/03/10 17:55:59
    10   0.96949       38.51
 ********************  begin active keff cycles  *********************
master set rendezvous nps =    111427       10/03/10 17:56:37
    11   0.96944       45.73
master set rendezvous nps =    121536       10/03/10 17:57:13
    12   0.97127       53.60        2    0.97035    0.00092      74471
master set rendezvous nps =    131558       10/03/10 17:57:52
    13   0.97887       62.04        3    0.97319    0.00289       4822
master set rendezvous nps =    141511       10/03/10 17:58:29
    14   0.97160       71.13        4    0.97279    0.00208       6695
master set rendezvous nps =    151271       10/03/10 17:59:07
    15   0.96715       80.80        5    0.97167    0.00197       5766
master set rendezvous nps =    161322       10/03/10 17:59:44
    16   0.95758       91.11        6    0.96932    0.00285       2207
master set rendezvous nps =    171091       10/03/10 18:00:22
    17   0.96267      102.02        7    0.96837    0.00259       2209
master set rendezvous nps =    181181       10/03/10 18:00:59
    18   0.96803      113.53        8    0.96833    0.00224       2493
master set rendezvous nps =    191201       10/03/10 18:01:35
    19   0.97293      125.65        9    0.96884    0.00204       2589
master set rendezvous nps =    201194       10/03/10 18:02:13
"

nps_stat "
master starting      12 by       1 subtasks   10/03/10 18:05:07   10000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 18:05:09
master set rendezvous nps =     10000       10/03/10 18:05:11

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.65590        1.95
master set rendezvous nps =     16763       10/03/10 18:05:21
     2   0.92812        4.31
master set rendezvous nps =     30972       10/03/10 18:05:27
     3   0.95567        7.96
master set rendezvous nps =     41339       10/03/10 18:05:36
     4   0.96221       12.57
master set rendezvous nps =     51442       10/03/10 18:05:43
     5   0.96315       18.16
master set rendezvous nps =     61462       10/03/10 18:05:51
     6   0.97242       24.73
master set rendezvous nps =     71564       10/03/10 18:05:58
     7   0.96930       32.30
master set rendezvous nps =     81327       10/03/10 18:06:05
     8   0.97291       40.82
master set rendezvous nps =     91351       10/03/10 18:06:13
     9   0.98733       50.34
master set rendezvous nps =    101598       10/03/10 18:06:20
    10   0.96949       60.86
 ********************  begin active keff cycles  *********************
master set rendezvous nps =    111427       10/03/10 18:06:27
    11   0.96944       72.35
master set rendezvous nps =    121536       10/03/10 18:06:35
    12   0.97127       84.82        2    0.97035    0.00092      46879
master set rendezvous nps =    131558       10/03/10 18:06:42
    13   0.97887       98.28        3    0.97319    0.00289       3032
master set rendezvous nps =    141511       10/03/10 18:06:49
    14   0.97160      112.71        4    0.97279    0.00208       4211
master set rendezvous nps =    151271       10/03/10 18:06:57
    15   0.96715      128.11        5    0.97167    0.00197       3625
master set rendezvous nps =    161322       10/03/10 18:07:04
    16   0.95758      144.50        6    0.96932    0.00285       1388
master set rendezvous nps =    171091       10/03/10 18:07:11
    17   0.96267      161.84        7    0.96837    0.00259       1390
master set rendezvous nps =    181181       10/03/10 18:07:18
    18   0.96803      180.18        8    0.96833    0.00224       1567
master set rendezvous nps =    191201       10/03/10 18:07:26
    19   0.97293      199.50        9    0.96884    0.00204       1627
master set rendezvous nps =    201194       10/03/10 18:07:33
    20   0.97609      219.80       10    0.96956    0.00196       1534
master set rendezvous nps =    211164       10/03/10 18:07:40
    21   0.98152      241.08       11    0.97065    0.00208       1206
master set rendezvous nps =    221398       10/03/10 18:07:48
    22   0.97263      263.37       12    0.97081    0.00191       1279
master set rendezvous nps =    231432       10/03/10 18:07:55
    23   0.95972      286.63       13    0.96996    0.00195       1094
master set rendezvous nps =    241320       10/03/10 18:08:02
    24   0.96168      310.87       14    0.96937    0.00190       1040
master set rendezvous nps =    251365       10/03/10 18:08:10
    25   0.97095      336.10       15    0.96948    0.00177       1087
master set rendezvous nps =    261628       10/03/10 18:08:17
    26   0.96902      362.32       16    0.96945    0.00166       1133
master set rendezvous nps =    271644       10/03/10 18:08:24
    27   0.97526      389.53       17    0.96979    0.00159       1125
master set rendezvous nps =    281825       10/03/10 18:08:32
    28   0.97561      417.74       18    0.97011    0.00154       1115
master set rendezvous nps =    291907       10/03/10 18:08:39
    29   0.97730      446.93       19    0.97049    0.00150       1079
master set rendezvous nps =    301865       10/03/10 18:08:47
    30   0.96467      477.10       20    0.97020    0.00146       1067
master set rendezvous nps =    311867       10/03/10 18:08:54
    31   0.96615      508.26       21    0.97001    0.00140       1076
master set rendezvous nps =    321876       10/03/10 18:09:01
"

nps_stat "
master starting      24 by       1 subtasks   10/03/10 18:16:31   10000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 18:16:35
master set rendezvous nps =     10000       10/03/10 18:16:40

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.65590        2.29
master set rendezvous nps =     16763       10/03/10 18:16:49
     2   0.92812        5.32
master set rendezvous nps =     30972       10/03/10 18:16:56
     3   0.95567       10.47
master set rendezvous nps =     41339       10/03/10 18:17:06
     4   0.96221       17.27
master set rendezvous nps =     51442       10/03/10 18:17:14
     5   0.96315       25.73
master set rendezvous nps =     61462       10/03/10 18:17:23
     6   0.97242       35.85
master set rendezvous nps =     71564       10/03/10 18:17:32
     7   0.96930       47.64
master set rendezvous nps =     81327       10/03/10 18:17:40
     8   0.97291       61.06
master set rendezvous nps =     91351       10/03/10 18:17:49
     9   0.98733       76.14
master set rendezvous nps =    101598       10/03/10 18:17:57
    10   0.96949       92.91
 ********************  begin active keff cycles  *********************
master set rendezvous nps =    111427       10/03/10 18:18:06
    11   0.96944      111.32
master set rendezvous nps =    121536       10/03/10 18:18:15
    12   0.97127      131.38        2    0.97035    0.00092      29197
master set rendezvous nps =    131558       10/03/10 18:18:23
    13   0.97887      153.11        3    0.97319    0.00289       1885
master set rendezvous nps =    141511       10/03/10 18:18:32
    14   0.97160      176.47        4    0.97279    0.00208       2613
master set rendezvous nps =    151271       10/03/10 18:18:40
    15   0.96715      201.45        5    0.97167    0.00197       2246
master set rendezvous nps =    161322       10/03/10 18:18:49
    16   0.95758      228.08        6    0.96932    0.00285        859
master set rendezvous nps =    171091       10/03/10 18:18:57
    17   0.96267      256.34        7    0.96837    0.00259        859
master set rendezvous nps =    181181       10/03/10 18:19:06
    18   0.96803      286.25        8    0.96833    0.00224        967
master set rendezvous nps =    191201       10/03/10 18:19:14
    19   0.97293      317.81        9    0.96884    0.00204       1003
master set rendezvous nps =    201194       10/03/10 18:19:23
    20   0.97609      351.03       10    0.96956    0.00196        945
master set rendezvous nps =    211164       10/03/10 18:19:31
    21   0.98152      385.90       11    0.97065    0.00208        742
master set rendezvous nps =    221398       10/03/10 18:19:40
    22   0.97263      422.46       12    0.97081    0.00191        786
master set rendezvous nps =    231432       10/03/10 18:19:48
    23   0.95972      460.67       13    0.96996    0.00195        672
master set rendezvous nps =    241320       10/03/10 18:19:57
    24   0.96168      500.52       14    0.96937    0.00190        638
master set rendezvous nps =    251365       10/03/10 18:20:05
    25   0.97095      542.02       15    0.96948    0.00177        666
master set rendezvous nps =    261628       10/03/10 18:20:14
    26   0.96902      585.19       16    0.96945    0.00166        694
master set rendezvous nps =    271644       10/03/10 18:20:23
    27   0.97526      630.03       17    0.96979    0.00159        688
master set rendezvous nps =    281825       10/03/10 18:20:31
    28   0.97561      676.53       18    0.97011    0.00154        682
master set rendezvous nps =    291907       10/03/10 18:20:40
    29   0.97730      724.69       19    0.97049    0.00150        660
master set rendezvous nps =    301865       10/03/10 18:20:48
    30   0.96467      774.49       20    0.97020    0.00146        652
master set rendezvous nps =    311867       10/03/10 18:20:57
    31   0.96615      825.93       21    0.97001    0.00140        657
master set rendezvous nps =    321876       10/03/10 18:21:06
    32   0.96696      879.03       22    0.96987    0.00134        666
master set rendezvous nps =    331875       10/03/10 18:21:14
    33   0.97695      933.76       23    0.97018    0.00132        645
master set rendezvous nps =    341999       10/03/10 18:21:23
"

nps_stat "
master starting      24 by       1 subtasks   10/03/10 18:33:23   2000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 18:33:26
master set rendezvous nps =      2000       10/03/10 18:33:31

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.65116        1.05
master set rendezvous nps =      3328       10/03/10 18:33:36
     2   0.91810        1.97
master set rendezvous nps =      6109       10/03/10 18:33:41
     3   0.94988        3.31
master set rendezvous nps =      8192       10/03/10 18:33:46
     4   0.97093        5.00
master set rendezvous nps =     10191       10/03/10 18:33:51
     5   0.95458        7.05
master set rendezvous nps =     12195       10/03/10 18:33:56
     6   0.97603        9.44
master set rendezvous nps =     14222       10/03/10 18:34:01
     7   0.97184       12.18
master set rendezvous nps =     16184       10/03/10 18:34:06
     8   0.99753       15.28
master set rendezvous nps =     18250       10/03/10 18:34:12
     9   0.97254       18.72
master set rendezvous nps =     20293       10/03/10 18:34:17
    10   0.97107       22.53
 ********************  begin active keff cycles  *********************
master set rendezvous nps =     22237       10/03/10 18:34:22
    11   0.96764       26.67
master set rendezvous nps =     24228       10/03/10 18:34:27
    12   0.97317       31.17        2    0.97040    0.00276      14262
master set rendezvous nps =     26247       10/03/10 18:34:32
    13   0.97075       36.02        3    0.97052    0.00160      27277
master set rendezvous nps =     28201       10/03/10 18:34:37
    14   0.96726       41.21        4    0.96970    0.00139      25872
master set rendezvous nps =     30200       10/03/10 18:34:42
    15   0.97718       46.74        5    0.97120    0.00185      11442
master set rendezvous nps =     32205       10/03/10 18:34:47
    16   0.95453       52.61        6    0.96842    0.00316       3120
master set rendezvous nps =     34103       10/03/10 18:34:52
    17   0.97778       58.82        7    0.96976    0.00299       2903
master set rendezvous nps =     36220       10/03/10 18:34:57
    18   0.97161       65.40        8    0.96999    0.00260       3253
master set rendezvous nps =     38185       10/03/10 18:35:02
    19   0.97799       72.31        9    0.97088    0.00246       3135
master set rendezvous nps =     40268       10/03/10 18:35:07
    20   0.97284       79.59       10    0.97108    0.00221       3394
master set rendezvous nps =     42242       10/03/10 18:35:13
    21   0.95532       87.22       11    0.96964    0.00246       2408
master set rendezvous nps =     44196       10/03/10 18:35:18
    22   0.98482       95.19       12    0.97091    0.00257       1957
master set rendezvous nps =     46249       10/03/10 18:35:23
    23   0.96160      103.52       13    0.97019    0.00247       1898
master set rendezvous nps =     48211       10/03/10 18:35:28
    24   0.95075      112.20       14    0.96880    0.00268       1458
master set rendezvous nps =     50184       10/03/10 18:35:33
    25   0.96071      121.22       15    0.96826    0.00255       1459
master set rendezvous nps =     52131       10/03/10 18:35:38
    26   1.00088      130.59       16    0.97030    0.00314        884
master set rendezvous nps =     54225       10/03/10 18:35:43
    27   0.99539      140.32       17    0.97178    0.00330        737
master set rendezvous nps =     56205       10/03/10 18:35:48
    28   0.98994      150.40       18    0.97279    0.00327        693
master set rendezvous nps =     58205       10/03/10 18:35:53
    29   0.96947      160.82       19    0.97261    0.00310        713
master set rendezvous nps =     60149       10/03/10 18:35:59
    30   0.97930      171.59       20    0.97295    0.00296        727
master set rendezvous nps =     62132       10/03/10 18:36:04
    31   0.96922      182.71       21    0.97277    0.00282        744
master set rendezvous nps =     64130       10/03/10 18:36:09
    32   0.95747      194.17       22    0.97207    0.00278        715
master set rendezvous nps =     66063       10/03/10 18:36:14
"

nps_stat "
master starting      24 by       1 subtasks   10/03/10 18:39:12    20000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 18:39:15
master set rendezvous nps =     20000       10/03/10 18:39:20

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66118        3.70
master set rendezvous nps =     33717       10/03/10 18:39:32
     2   0.92676        9.33
master set rendezvous nps =     61808       10/03/10 18:39:42
     3   0.95298       19.06
master set rendezvous nps =     82327       10/03/10 18:39:57
     4   0.96164       32.08
master set rendezvous nps =    102198       10/03/10 18:40:10
     5   0.95949       48.33
master set rendezvous nps =    122310       10/03/10 18:40:23
     6   0.96589       67.89
master set rendezvous nps =    142448       10/03/10 18:40:36
     7   0.96885       90.74
master set rendezvous nps =    162445       10/03/10 18:40:48
     8   0.96914      116.89
master set rendezvous nps =    182380       10/03/10 18:41:01
     9   0.96844      146.35
master set rendezvous nps =    202445       10/03/10 18:41:14
    10   0.96642      179.08
 ********************  begin active keff cycles  *********************
master set rendezvous nps =    222441       10/03/10 18:41:27
    11   0.97588      215.10
master set rendezvous nps =    242620       10/03/10 18:41:40
    12   0.96795      254.45        2    0.97191    0.00397        796
master set rendezvous nps =    262316       10/03/10 18:41:53
    13   0.96900      297.05        3    0.97094    0.00249       1290
master set rendezvous nps =    282353       10/03/10 18:42:06
    14   0.97147      342.94        4    0.97107    0.00176       1848
master set rendezvous nps =    302388       10/03/10 18:42:19
    15   0.96723      392.12        5    0.97031    0.00157       1796
master set rendezvous nps =    322386       10/03/10 18:42:32
    16   0.96448      444.60        6    0.96933    0.00161       1369
master set rendezvous nps =    342201       10/03/10 18:42:44
    17   0.96935      500.36        7    0.96934    0.00136       1585
master set rendezvous nps =    362306       10/03/10 18:42:57
    18   0.96563      559.42        8    0.96887    0.00126       1543
master set rendezvous nps =    382215       10/03/10 18:43:10
    19   0.96711      621.78        9    0.96868    0.00113       1653
master set rendezvous nps =    402240       10/03/10 18:43:23
    20   0.96904      687.46       10    0.96871    0.00101       1797
master set rendezvous nps =    422244       10/03/10 18:43:36
    21   0.97128      756.43       11    0.96895    0.00095       1817
master set rendezvous nps =    442332       10/03/10 18:43:49
    22   0.97758      828.71       12    0.96967    0.00112       1146
master set rendezvous nps =    462566       10/03/10 18:44:02
    23   0.96907      904.34       13    0.96962    0.00103       1210
master set rendezvous nps =    482504       10/03/10 18:44:15
    24   0.97328      983.25       14    0.96988    0.00099       1186
master set rendezvous nps =    502500       10/03/10 18:44:28
    25   0.96260     1065.44       15    0.96940    0.00104        972
master set rendezvous nps =    522145       10/03/10 18:44:41
    26   0.96908     1150.89       16    0.96938    0.00098       1013
master set rendezvous nps =    542273       10/03/10 18:44:54
    27   0.97178     1239.63       17    0.96952    0.00093       1028
master set rendezvous nps =    562446       10/03/10 18:45:07
    28   0.96297     1331.68       18    0.96915    0.00095        907
master set rendezvous nps =    582045       10/03/10 18:45:20
    29   0.97430     1426.98       19    0.96943    0.00094        858
master set rendezvous nps =    602278       10/03/10 18:45:33
    30   0.97777     1525.61       20    0.96984    0.00098        725
master set rendezvous nps =    622334       10/03/10 18:45:46
    31   0.97828     1627.53       21    0.97024    0.00102        629
master set rendezvous nps =    642339       10/03/10 18:45:59
    32   0.96952     1732.75       22    0.97021    0.00097        644
master set rendezvous nps =    662077       10/03/10 18:46:12
    33   0.97423     1841.23       23    0.97039    0.00094        637
master set rendezvous nps =    681998       10/03/10 18:46:25
    34   0.97456     1952.99       24    0.97056    0.00092        628
master set rendezvous nps =    702034       10/03/10 18:46:37
    35   0.96714     2068.03       25    0.97042    0.00089        626
master set rendezvous nps =    721818       10/03/10 18:46:50
    36   0.97106     2186.35       26    0.97045    0.00086        638
master set rendezvous nps =    741925       10/03/10 18:47:03
    37   0.97697     2307.99       27    0.97069    0.00086        598
master set rendezvous nps =    761969       10/03/10 18:47:16
"


nps_stat "
master starting      24 by       1 subtasks   10/03/10 19:00:51   50,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 19:00:54
master set rendezvous nps =     50000       10/03/10 19:00:59

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66545        8.15
master set rendezvous nps =     84761       10/03/10 19:01:21
     2   0.93114       21.76
master set rendezvous nps =    154695       10/03/10 19:01:41
     3   0.95260       45.69
master set rendezvous nps =    206114       10/03/10 19:02:12
     4   0.96200       77.86
master set rendezvous nps =    257027       10/03/10 19:02:39
     5   0.96722      118.32
master set rendezvous nps =    307392       10/03/10 19:03:05
     6   0.96973      167.05
master set rendezvous nps =    357514       10/03/10 19:03:32
     7   0.97325      224.01
master set rendezvous nps =    407592       10/03/10 19:03:58
     8   0.97034      289.24
master set rendezvous nps =    457483       10/03/10 19:04:24
     9   0.97340      362.70
master set rendezvous nps =    507398       10/03/10 19:04:50
    10   0.96580      444.42
 ********************  begin active keff cycles  *********************
master set rendezvous nps =    557045       10/03/10 19:05:16
    11   0.97097      534.34
master set rendezvous nps =    607429       10/03/10 19:05:42
    12   0.96841      632.57        2    0.96969    0.00128       3044
master set rendezvous nps =    657320       10/03/10 19:06:08
    13   0.97156      739.05        3    0.97032    0.00097       3417
master set rendezvous nps =    707468       10/03/10 19:06:35
    14   0.96981      853.82        4    0.97019    0.00070       4752
master set rendezvous nps =    757682       10/03/10 19:07:01
    15   0.96877      976.86        5    0.96991    0.00061       4770
master set rendezvous nps =    807795       10/03/10 19:07:27
    16   0.97050     1108.17        6    0.97000    0.00051       5525
master set rendezvous nps =    857766       10/03/10 19:07:53
    17   0.97055     1247.72        7    0.97008    0.00044       6189
master set rendezvous nps =    907824       10/03/10 19:08:19
    18   0.97400     1395.53        8    0.97057    0.00062       2590
master set rendezvous nps =    957679       10/03/10 19:08:46
    19   0.96926     1551.58        9    0.97043    0.00056       2670
master set rendezvous nps =   1007458       10/03/10 19:09:12
    20   0.97259     1715.89       10    0.97064    0.00055       2455
master set rendezvous nps =   1057685       10/03/10 19:09:38
    21   0.96458     1888.45       11    0.97009    0.00074       1183
master set rendezvous nps =   1107169       10/03/10 19:10:04
    22   0.96517     2069.19       12    0.96968    0.00079        923
master set rendezvous nps =   1157180       10/03/10 19:10:30
    23   0.97050     2258.16       13    0.96974    0.00073        970
master set rendezvous nps =   1207184       10/03/10 19:10:56
    24   0.96957     2455.39       14    0.96973    0.00068       1020
master set rendezvous nps =   1257404       10/03/10 19:11:23
    25   0.97058     2660.91       15    0.96979    0.00063       1059
master set rendezvous nps =   1307215       10/03/10 19:11:49
    26   0.96704     2874.69       16    0.96962    0.00062       1018
master set rendezvous nps =   1356683       10/03/10 19:12:15
    27   0.96779     3096.68       17    0.96951    0.00059       1022
master set rendezvous nps =   1406715       10/03/10 19:12:41
    28   0.96900     3326.94       18    0.96948    0.00056       1055
master set rendezvous nps =   1456734       10/03/10 19:13:07
    29   0.97558     3565.47       19    0.96980    0.00062        794
master set rendezvous nps =   1507051       10/03/10 19:13:33
    30   0.97060     3812.32       20    0.96984    0.00059        814
master set rendezvous nps =   1556731       10/03/10 19:13:59
    31   0.96827     4067.38       21    0.96977    0.00056        821
master set rendezvous nps =   1606297       10/03/10 19:14:25
    32   0.96558     4330.65       22    0.96958    0.00057        748
master set rendezvous nps =   1656372       10/03/10 19:14:51
    33   0.97286     4602.22       23    0.96972    0.00056        716
master set rendezvous nps =   1706983       10/03/10 19:15:17
    34   0.96741     4882.11       24    0.96962    0.00055        709
master set rendezvous nps =   1756778       10/03/10 19:15:44
    35   0.96927     5170.24       25    0.96961    0.00052        723
master set rendezvous nps =   1806847       10/03/10 19:16:10
    36   0.97060     5466.62       26    0.96965    0.00051        733
master set rendezvous nps =   1857104       10/03/10 19:16:36
    37   0.97185     5771.28       27    0.96973    0.00049        726
master set rendezvous nps =   1907534       10/03/10 19:17:02
"

nps_stat "
master starting       2 by       1 subtasks   10/03/10 22:45:30  50,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 22:45:31
master set rendezvous nps =     50000       10/03/10 22:45:32

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66545        5.11
master set rendezvous nps =     84761       10/03/10 22:48:04
     2   0.93114       11.87
master set rendezvous nps =    154695       10/03/10 22:50:12
     3   0.95260       23.53
master set rendezvous nps =    206114       10/03/10 22:53:42
     4   0.96200       37.40
master set rendezvous nps =    257027       10/03/10 22:56:34
     5   0.96722       54.08
master set rendezvous nps =    307392       10/03/10 22:59:24
     6   0.96973       73.48
master set rendezvous nps =    357514       10/03/10 23:02:12
"

nps_stat "
master starting       7 by       1 subtasks   10/04/10 00:05:09   mcnpx phoenix 2000nps
master sending static commons...
master sharing runtpe file...
master completed initialization broadcasts.
rendezvous at nps =        2000 # of microtasks =       7    10/04/10 00:05:12

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   1.08436      0.22
rendezvous at nps =        4165 # of microtasks =       7    10/04/10 00:05:14
     2   1.03680      0.44
rendezvous at nps =        6061 # of microtasks =       7    10/04/10 00:05:16
     3   0.98583      0.64
rendezvous at nps =        7970 # of microtasks =       7    10/04/10 00:05:18
     4   0.97724      0.85
rendezvous at nps =        9925 # of microtasks =       7    10/04/10 00:05:20
     5   0.97527      1.05
rendezvous at nps =       11956 # of microtasks =       7    10/04/10 00:05:22
     6   0.96204      1.27
rendezvous at nps =       13944 # of microtasks =       7    10/04/10 00:05:25
     7   0.97146      1.47
rendezvous at nps =       15885 # of microtasks =       7    10/04/10 00:05:27
     8   0.98807      1.68
rendezvous at nps =       17899 # of microtasks =       7    10/04/10 00:05:29
     9   0.96722      1.89
rendezvous at nps =       19877 # of microtasks =       7    10/04/10 00:05:32
"

nps_stat "
master starting       6 by       1 subtasks   10/03/10 23:29:11   10,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 23:29:12
master set rendezvous nps =     10000       10/03/10 23:29:13

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.65590        1.18
master set rendezvous nps =     16763       10/03/10 23:29:25
     2   0.92812        2.80
master set rendezvous nps =     30972       10/03/10 23:29:32
     3   0.95567        5.52
master set rendezvous nps =     41339       10/03/10 23:29:45
     4   0.96221        9.04
master set rendezvous nps =     51442       10/03/10 23:29:56
     5   0.96315       13.37
master set rendezvous nps =     61462       10/03/10 23:30:07
     6   0.97242       18.53
master set rendezvous nps =     71564       10/03/10 23:30:18
     7   0.96930       24.51
master set rendezvous nps =     81327       10/03/10 23:30:29
     8   0.97291       31.29
master set rendezvous nps =     91351       10/03/10 23:30:39
     9   0.98733       38.91
master set rendezvous nps =    101598       10/03/10 23:30:50
    10   0.96949       47.36
 ********************  begin active keff cycles  *********************
master set rendezvous nps =    111427       10/03/10 23:31:01
    11   0.96944       56.62
master set rendezvous nps =    121536       10/03/10 23:31:12
    12   0.97127       66.70        2    0.97035    0.00092      58077
master set rendezvous nps =    131558       10/03/10 23:31:22
    13   0.97887       77.61        3    0.97319    0.00289       3751
master set rendezvous nps =    141511       10/03/10 23:31:33
    14   0.97160       89.33        4    0.97279    0.00208       5203
master set rendezvous nps =    151271       10/03/10 23:31:44
    15   0.96715      101.85        5    0.97167    0.00197       4474
 source distribution to file X.test.srctp         cycle =    15
 writing restart dump on runtpe
 saving runtpe file
 dump    2 on file X.test.runtp   nps =    151271    coll =       22531643
                              ctm =    101.85     nrn =      793811286
master set rendezvous nps =    161322       10/03/10 23:31:55
    16   0.95758      115.20        6    0.96932    0.00285       1711
master set rendezvous nps =    171091       10/03/10 23:32:05
    17   0.96267      129.35        7    0.96837    0.00259       1711
master set rendezvous nps =    181181       10/03/10 23:32:16
    18   0.96803      144.33        8    0.96833    0.00224       1929
master set rendezvous nps =    191201       10/03/10 23:32:27
    19   0.97293      160.13        9    0.96884    0.00204       2000
master set rendezvous nps =    201194       10/03/10 23:32:38
    20   0.97609      176.75       10    0.96956    0.00196       1885
master set rendezvous nps =    211164       10/03/10 23:32:48
    21   0.98152      194.20       11    0.97065    0.00208       1480
master set rendezvous nps =    221398       10/03/10 23:32:59
    22   0.97263      212.48       12    0.97081    0.00191       1568
 source distribution to file X.test.srctp         cycle =    22
 writing restart dump on runtpe
 saving runtpe file
 dump    3 on file X.test.runtp   nps =    221398    coll =       54138163
                              ctm =    212.48     nrn =     1159906350
master set rendezvous nps =    231432       10/03/10 23:33:10
    23   0.95972      231.58       13    0.96996    0.00195       1341
master set rendezvous nps =    241320       10/03/10 23:33:21
    24   0.96168      251.50       14    0.96937    0.00190       1274
master set rendezvous nps =    251365       10/03/10 23:33:31
    25   0.97095      272.23       15    0.96948    0.00177       1330
master set rendezvous nps =    261628       10/03/10 23:33:42
    26   0.96902      293.80       16    0.96945    0.00166       1386
master set rendezvous nps =    271644       10/03/10 23:33:53
    27   0.97526      316.20       17    0.96979    0.00159       1375
master set rendezvous nps =    281825       10/03/10 23:34:04
    28   0.97561      339.42       18    0.97011    0.00154       1362
 source distribution to file X.test.srctp         cycle =    28
 writing restart dump on runtpe
 saving runtpe file
 dump    4 on file X.test.runtp   nps =    281825    coll =       81134510
                              ctm =    339.42     nrn =     1473075878
master set rendezvous nps =    291907       10/03/10 23:34:15
    29   0.97730      363.47       19    0.97049    0.00150       1318
master set rendezvous nps =    301865       10/03/10 23:34:26
    30   0.96467      388.33       20    0.97020    0.00146       1303
master set rendezvous nps =    311867       10/03/10 23:34:36
    31   0.96615      414.01       21    0.97001    0.00140       1313
master set rendezvous nps =    321876       10/03/10 23:34:47
    32   0.96696      440.52       22    0.96987    0.00134       1332
master set rendezvous nps =    331875       10/03/10 23:34:58
    33   0.97695      467.84       23    0.97018    0.00132       1291
 source distribution to file X.test.srctp         cycle =    33
 writing restart dump on runtpe
 saving runtpe file
 dump    5 on file X.test.runtp   nps =    331875    coll =      103768873
                              ctm =    467.84     nrn =     1734843231
master set rendezvous nps =    341999       10/03/10 23:35:08
    34   0.97201      495.99       24    0.97025    0.00126       1315
master set rendezvous nps =    351964       10/03/10 23:35:19
    35   0.96294      524.97       25    0.96996    0.00125       1268
master set rendezvous nps =    361875       10/03/10 23:35:30
    36   0.96844      554.75       26    0.96990    0.00120       1290
master set rendezvous nps =    371970       10/03/10 23:35:41
    37   0.97324      585.37       27    0.97003    0.00116       1299
master set rendezvous nps =    381970       10/03/10 23:35:52
    38   0.96751      616.81       28    0.96994    0.00112       1313
 source distribution to file X.test.srctp         cycle =    38
 writing restart dump on runtpe
 saving runtpe file
 dump    6 on file X.test.runtp   nps =    381970    coll =      126386995
                              ctm =    616.81     nrn =     1997136505
master set rendezvous nps =    392024       10/03/10 23:36:03
    39   0.97289      649.06       29    0.97004    0.00109       1323
master set rendezvous nps =    402122       10/03/10 23:36:13
    40   0.96872      682.14       30    0.96999    0.00105       1341
master set rendezvous nps =    411976       10/03/10 23:36:24
"

nps_stat "
master starting       6 by       1 subtasks   10/03/10 23:38:53   50,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 23:38:54
master set rendezvous nps =     50000       10/03/10 23:38:55

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66545        4.57
master set rendezvous nps =     84761       10/03/10 23:39:41
     2   0.93114       11.81
master set rendezvous nps =    154695       10/03/10 23:40:18
     3   0.95260       24.46
master set rendezvous nps =    206114       10/03/10 23:41:21
     4   0.96200       41.03
master set rendezvous nps =    257027       10/03/10 23:42:13
     5   0.96722       61.68
master set rendezvous nps =    307392       10/03/10 23:43:05
     6   0.96973       86.41
master set rendezvous nps =    357514       10/03/10 23:43:56
     7   0.97325      115.18
master set rendezvous nps =    407592       10/03/10 23:44:47
     8   0.97034      148.02
master set rendezvous nps =    457483       10/03/10 23:45:38
"

nps_stat "
master starting      12 by       1 subtasks   10/03/10 23:47:18   50,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 23:47:20
master set rendezvous nps =     50000       10/03/10 23:47:22

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66545        5.22
master set rendezvous nps =     84761       10/03/10 23:47:49
     2   0.93114       13.67
master set rendezvous nps =    154695       10/03/10 23:48:10
     3   0.95260       28.33
master set rendezvous nps =    206114       10/03/10 23:48:45
     4   0.96200       47.81
master set rendezvous nps =    257027       10/03/10 23:49:14
     5   0.96722       72.19
master set rendezvous nps =    307392       10/03/10 23:49:43
     6   0.96973      101.45
master set rendezvous nps =    357514       10/03/10 23:50:12
     7   0.97325      135.55
master set rendezvous nps =    407592       10/03/10 23:50:40
     8   0.97034      174.54
master set rendezvous nps =    457483       10/03/10 23:51:10
     9   0.97340      218.39
master set rendezvous nps =    507398       10/03/10 23:51:39
    10   0.96580      267.11
 ********************  begin active keff cycles  *********************
master set rendezvous nps =    557045       10/03/10 23:52:08
    11   0.97097      320.67
master set rendezvous nps =    607429       10/03/10 23:52:37
    12   0.96841      379.14        2    0.96969    0.00128       5111
master set rendezvous nps =    657320       10/03/10 23:53:06
    13   0.97156      442.48        3    0.97032    0.00097       5741
master set rendezvous nps =    707468       10/03/10 23:53:35
    14   0.96981      510.70        4    0.97019    0.00070       7987
master set rendezvous nps =    757682       10/03/10 23:54:04
    15   0.96877      583.80        5    0.96991    0.00061       8020
master set rendezvous nps =    807795       10/03/10 23:54:32
"

nps_stat "
master starting      12 by       1 subtasks   10/03/10 23:56:43  100,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/03/10 23:56:45
master set rendezvous nps =    100000       10/03/10 23:56:47

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66433       10.23
master set rendezvous nps =    169543       10/03/10 23:57:39
     2   0.92531       27.03
master set rendezvous nps =    269543       10/03/10 23:58:20
master set rendezvous nps =    308788       10/03/10 23:59:09
     3   0.95419       80.86
master set rendezvous nps =    408788       10/03/10 23:59:29
master set rendezvous nps =    412365       10/04/10 00:00:23
     4   0.96186      157.16
master set rendezvous nps =    512365       10/04/10 00:00:27
master set rendezvous nps =    513357       10/04/10 00:01:22
     5   0.96463      253.12
master set rendezvous nps =    613357       10/04/10 00:01:24
master set rendezvous nps =    613599       10/04/10 00:02:20
     6   0.96939      368.46
master set rendezvous nps =    713599       10/04/10 00:02:22
master set rendezvous nps =    714214       10/04/10 00:03:17
     7   0.97159      503.16
master set rendezvous nps =    814214       10/04/10 00:03:19
master set rendezvous nps =    814412       10/04/10 00:04:14
     8   0.97205      657.27
master set rendezvous nps =    914139       10/04/10 00:04:16
     9   0.96522      744.42
master set rendezvous nps =   1013581       10/04/10 00:05:11
"

nps_stat "
master starting      12 by       1 subtasks   10/04/10 00:07:22  90,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/04/10 00:07:24
master set rendezvous nps =     90000       10/04/10 00:07:27

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66419        8.91
master set rendezvous nps =    152511       10/04/10 00:08:13
     2   0.93114       23.78
master set rendezvous nps =    252511       10/04/10 00:08:50
master set rendezvous nps =    278554       10/04/10 00:09:40
     3   0.94985       72.68
master set rendezvous nps =    370010       10/04/10 00:09:54
     4   0.96459      107.35
master set rendezvous nps =    461208       10/04/10 00:10:45
     5   0.97056      150.84
master set rendezvous nps =    551763       10/04/10 00:11:37
     6   0.97214      203.10
master set rendezvous nps =    641466       10/04/10 00:12:28
     7   0.96775      264.05
master set rendezvous nps =    731283       10/04/10 00:13:19
     8   0.97253      333.74
master set rendezvous nps =    821442       10/04/10 00:14:10
"

nps_stat "
master starting      24 by       1 subtasks   10/04/10 00:15:50  90,000nps
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/04/10 00:15:53
master set rendezvous nps =     90000       10/04/10 00:15:58

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66419       14.11
master set rendezvous nps =    152511       10/04/10 00:16:37
     2   0.93114       38.33
master set rendezvous nps =    252511       10/04/10 00:17:09
master set rendezvous nps =    278554       10/04/10 00:17:52
     3   0.94985      119.35
master set rendezvous nps =    370010       10/04/10 00:18:06
     4   0.96459      176.88
master set rendezvous nps =    461208       10/04/10 00:18:50
     5   0.97056      249.39
master set rendezvous nps =    551763       10/04/10 00:19:34
     6   0.97214      336.81
master set rendezvous nps =    641466       10/04/10 00:20:18
     7   0.96775      439.01
master set rendezvous nps =    731283       10/04/10 00:21:01
"

nps_stat "
master starting       6 by       1 subtasks   10/04/10 09:38:44
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/04/10 09:38:45
master set rendezvous nps =     90000       10/04/10 09:38:46

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66419        7.88
master set rendezvous nps =    152511       10/04/10 09:40:05
     2   0.93114       20.69
master set rendezvous nps =    252511       10/04/10 09:41:09
master set rendezvous nps =    278554       10/04/10 09:42:36
     3   0.94985       62.14
master set rendezvous nps =    370010       10/04/10 09:42:59
     4   0.96459       91.67
master set rendezvous nps =    461208       10/04/10 09:44:30
     5   0.97056      128.52
master set rendezvous nps =    551763       10/04/10 09:46:02
     6   0.97214      172.61
master set rendezvous nps =    641466       10/04/10 09:47:33
     7   0.96775      223.92
master set rendezvous nps =    731283       10/04/10 09:49:04
     8   0.97253      282.47
master set rendezvous nps =    821442       10/04/10 09:50:35
     9   0.97440      348.27
master set rendezvous nps =    911638       10/04/10 09:52:06
    10   0.96959      421.34
 ********************  begin active keff cycles  *********************
master set rendezvous nps =   1001054       10/04/10 09:53:37
    11   0.97097      501.60
master set rendezvous nps =   1091467       10/04/10 09:55:08
    12   0.97098      589.15        2    0.97097    0.00000    3.0E+08
master set rendezvous nps =   1181008       10/04/10 09:56:39
    13   0.97161      683.92        3    0.97118    0.00021      78831
master set rendezvous nps =   1271029       10/04/10 09:58:10
    14   0.97145      785.94        4    0.97125    0.00016      95403
master set rendezvous nps =   1360603       10/04/10 09:59:41
    15   0.97247      895.21        5    0.97149    0.00028      26199
master set rendezvous nps =   1450381       10/04/10 10:01:12
    16   0.97187     1011.72        6    0.97156    0.00023      29275
master set rendezvous nps =   1540670       10/04/10 10:02:43
    17   0.96937     1135.51        7    0.97124    0.00037       9642
master set rendezvous nps =   1630186       10/04/10 10:04:15
    18   0.97362     1266.51        8    0.97154    0.00044       5839
master set rendezvous nps =   1720792       10/04/10 10:05:45
    19   0.97192     1404.83        9    0.97158    0.00039       6374
master set rendezvous nps =   1810642       10/04/10 10:07:15
    20   0.97293     1550.44       10    0.97172    0.00037       6039
master set rendezvous nps =   1900513       10/04/10 10:08:44
    21   0.96997     1703.36       11    0.97156    0.00037       5315
master set rendezvous nps =   1990796       10/04/10 10:10:13
    22   0.97151     1863.62       12    0.97156    0.00034       5668
master set rendezvous nps =   2080794       10/04/10 10:11:43
    23   0.97193     2031.19       13    0.97158    0.00031       5950
master set rendezvous nps =   2170538       10/04/10 10:13:13
    24   0.97123     2206.05       14    0.97156    0.00029       6213
master set rendezvous nps =   2260347       10/04/10 10:14:42
    25   0.96912     2388.22       15    0.97140    0.00032       4791
master set rendezvous nps =   2350185       10/04/10 10:16:11
    26   0.97103     2577.70       16    0.97137    0.00030       4965
master set rendezvous nps =   2440395       10/04/10 10:17:40
    27   0.96736     2774.49       17    0.97114    0.00037       3003
master set rendezvous nps =   2529933       10/04/10 10:19:09
    28   0.96914     2978.57       18    0.97103    0.00036       2817
master set rendezvous nps =   2619587       10/04/10 10:20:38
    29   0.96698     3189.94       19    0.97081    0.00040       2094
master set rendezvous nps =   2709575       10/04/10 10:22:06
    30   0.97351     3408.64       20    0.97095    0.00041       1918
master set rendezvous nps =   2800384       10/04/10 10:23:36
    31   0.97186     3634.70       21    0.97099    0.00039       1947
master set rendezvous nps =   2889849       10/04/10 10:25:06
    32   0.97035     3868.02       22    0.97096    0.00037       1984
master set rendezvous nps =   2979740       10/04/10 10:26:35
    33   0.96706     4108.64       23    0.97079    0.00039       1652
master set rendezvous nps =   3069217       10/04/10 10:28:04
    34   0.97108     4356.52       24    0.97081    0.00038       1687
master set rendezvous nps =   3159514       10/04/10 10:29:33
    35   0.97201     4611.75       25    0.97085    0.00036       1692
master set rendezvous nps =   3249718       10/04/10 10:31:03
    36   0.97153     4874.30       26    0.97088    0.00035       1716
master set rendezvous nps =   3339320       10/04/10 10:32:32
    37   0.97214     5144.14       27    0.97093    0.00034       1715
master set rendezvous nps =   3428791       10/04/10 10:34:01
"

nps_stat "
master starting      36 by       1 subtasks   10/04/10 10:36:26
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/04/10 10:36:31
master set rendezvous nps =     90000       10/04/10 10:36:40

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66419       14.62
master set rendezvous nps =    152511       10/04/10 10:37:21
     2   0.93114       39.43
master set rendezvous nps =    252511       10/04/10 10:37:57
master set rendezvous nps =    278554       10/04/10 10:38:43
     3   0.94985      122.50
master set rendezvous nps =    370010       10/04/10 10:39:01
     4   0.96459      181.42
master set rendezvous nps =    461208       10/04/10 10:39:49
     5   0.97056      255.72
master set rendezvous nps =    551763       10/04/10 10:40:36
     6   0.97214      345.33
master set rendezvous nps =    641466       10/04/10 10:41:24
     7   0.96775      450.17
master set rendezvous nps =    731283       10/04/10 10:42:12
     8   0.97253      570.26
master set rendezvous nps =    821442       10/04/10 10:42:59
     9   0.97440      705.64
master set rendezvous nps =    911638       10/04/10 10:43:46
    10   0.96959      856.36
 ********************  begin active keff cycles  *********************
master set rendezvous nps =   1001054       10/04/10 10:44:34
    11   0.97097     1022.29
master set rendezvous nps =   1091467       10/04/10 10:45:21
    12   0.97098     1203.54        2    0.97097    0.00000    1.4E+08
master set rendezvous nps =   1181008       10/04/10 10:46:09
    13   0.97161     1400.02        3    0.97118    0.00021      38074
master set rendezvous nps =   1271029       10/04/10 10:46:56
    14   0.97145     1611.81        4    0.97125    0.00016      46045
master set rendezvous nps =   1360603       10/04/10 10:47:44
    15   0.97247     1838.89        5    0.97149    0.00028      12636
master set rendezvous nps =   1450381       10/04/10 10:48:32
    16   0.97187     2081.25        6    0.97156    0.00023      14111
master set rendezvous nps =   1540670       10/04/10 10:49:19
    17   0.96937     2338.93        7    0.97124    0.00037       4645
master set rendezvous nps =   1630186       10/04/10 10:50:07
    18   0.97362     2611.84        8    0.97154    0.00044       2811
master set rendezvous nps =   1720792       10/04/10 10:50:54
    19   0.97192     2900.09        9    0.97158    0.00039       3068
master set rendezvous nps =   1810642       10/04/10 10:51:42
    20   0.97293     3203.60       10    0.97172    0.00037       2905
master set rendezvous nps =   1900513       10/04/10 10:52:30
    21   0.96997     3522.35       11    0.97156    0.00037       2556
master set rendezvous nps =   1990796       10/04/10 10:53:17
    22   0.97151     3856.45       12    0.97156    0.00034       2725
master set rendezvous nps =   2080794       10/04/10 10:54:05
    23   0.97193     4205.83       13    0.97158    0.00031       2860
master set rendezvous nps =   2170538       10/04/10 10:54:52
    24   0.97123     4570.48       14    0.97156    0.00029       2986
master set rendezvous nps =   2260347       10/04/10 10:55:40
    25   0.96912     4950.39       15    0.97140    0.00032       2302
master set rendezvous nps =   2350185       10/04/10 10:56:27
    26   0.97103     5345.55       16    0.97137    0.00030       2385
master set rendezvous nps =   2440395       10/04/10 10:57:15
    27   0.96736     5756.02       17    0.97114    0.00037       1442
master set rendezvous nps =   2529933       10/04/10 10:58:02
    28   0.96914     6181.70       18    0.97103    0.00036       1353
master set rendezvous nps =   2619587       10/04/10 10:58:49
    29   0.96698     6622.63       19    0.97081    0.00040       1005
master set rendezvous nps =   2709575       10/04/10 10:59:37
    30   0.97351     7078.85       20    0.97095    0.00041        921
master set rendezvous nps =   2800384       10/04/10 11:00:24
    31   0.97186     7550.43       21    0.97099    0.00039        935
master set rendezvous nps =   2889849       10/04/10 11:01:12
    32   0.97035     8037.21       22    0.97096    0.00037        952
master set rendezvous nps =   2979740       10/04/10 11:02:00
"

nps_stat "
master starting      24 by       1 subtasks   10/04/10 11:53:55
master sending static commons...
master task sent     98727 words to subtasks.
master sending dynamic commons...
master task sent   1221672 words to subtasks.
master sending cross section data...
master completed initialization broadcasts.
master set rendezvous nps =       200       10/04/10 11:53:59
master set rendezvous nps =    200000       10/04/10 11:54:07

 cycle    k(col)       ctm     active     k(col)    std dev        fom
     1   0.66532       30.56
master set rendezvous nps =    300000       10/04/10 11:55:28
master set rendezvous nps =    339488       10/04/10 11:56:19
     2   0.92782      130.23
master set rendezvous nps =    439488       10/04/10 11:56:43
master set rendezvous nps =    539488       10/04/10 11:57:27
master set rendezvous nps =    617773       10/04/10 11:58:12
     3   0.95466      374.22
master set rendezvous nps =    717773       10/04/10 11:58:47
master set rendezvous nps =    817773       10/04/10 11:59:36
master set rendezvous nps =    824287       10/04/10 12:00:25
     4   0.96344      737.42
master set rendezvous nps =    924287       10/04/10 12:00:34
master set rendezvous nps =   1024287       10/04/10 12:01:24
master set rendezvous nps =   1026644       10/04/10 12:02:13
     5   0.96500     1201.41
master set rendezvous nps =   1126644       10/04/10 12:02:19
master set rendezvous nps =   1226644       10/04/10 12:03:09
master set rendezvous nps =   1227231       10/04/10 12:03:58
     6   0.97005     1765.27
master set rendezvous nps =   1327231       10/04/10 12:04:04
master set rendezvous nps =   1427231       10/04/10 12:04:54
master set rendezvous nps =   1428064       10/04/10 12:05:44
     7   0.97078     2428.48
master set rendezvous nps =   1528064       10/04/10 12:05:50
master set rendezvous nps =   1628064       10/04/10 12:06:42
master set rendezvous nps =   1628773       10/04/10 12:07:31
     8   0.96919     3191.22
master set rendezvous nps =   1728773       10/04/10 12:07:37
master set rendezvous nps =   1828649       10/04/10 12:08:27
     9   0.96876     3760.99
master set rendezvous nps =   1928649       10/04/10 12:09:17
master set rendezvous nps =   2027996       10/04/10 12:10:07
    10   0.96713     4396.88
 ********************  begin active keff cycles  *********************
master set rendezvous nps =   2127996       10/04/10 12:10:56
master set rendezvous nps =   2227488       10/04/10 12:11:46
    11   0.96707     5098.89
master set rendezvous nps =   2327488       10/04/10 12:12:36
master set rendezvous nps =   2426764       10/04/10 12:13:26
    12   0.96820     5866.98        2    0.96764    0.00056       2027
master set rendezvous nps =   2526764       10/04/10 12:14:15
master set rendezvous nps =   2626259       10/04/10 12:15:05
    13   0.96895     6701.16        3    0.96807    0.00054       1370
master set rendezvous nps =   2726259       10/04/10 12:15:54
master set rendezvous nps =   2826194       10/04/10 12:16:44
    14   0.97077     7601.44        4    0.96875    0.00078        485
master set rendezvous nps =   2926194       10/04/10 12:17:34
master set rendezvous nps =   3025920       10/04/10 12:18:24
    15   0.96978     8567.96        5    0.96896    0.00064        556
master set rendezvous nps =   3125920       10/04/10 12:19:13
master set rendezvous nps =   3225729       10/04/10 12:20:03
    16   0.96890     9600.46        6    0.96895    0.00052        668
master set rendezvous nps =   3325729       10/04/10 12:20:52
master set rendezvous nps =   3425729       10/04/10 12:21:42
master set rendezvous nps =   3426088       10/04/10 12:22:32
    17   0.96850    11256.06        7    0.96888    0.00044        695
master set rendezvous nps =   3526088       10/04/10 12:22:38
master set rendezvous nps =   3625959       10/04/10 12:23:27
    18   0.97013    12421.07        8    0.96904    0.00041        680
master set rendezvous nps =   3725959       10/04/10 12:24:17
master set rendezvous nps =   3825959       10/04/10 12:25:07
master set rendezvous nps =   3825999       10/04/10 12:25:56
    19   0.97134    14275.55        9    0.96929    0.00045        477
master set rendezvous nps =   3925999       10/04/10 12:26:02
master set rendezvous nps =   4025999       10/04/10 12:26:53
master set rendezvous nps =   4026092       10/04/10 12:27:43
    20   0.96700    16229.87       10    0.96907    0.00046        374
master set rendezvous nps =   4126092       10/04/10 12:27:49
master set rendezvous nps =   4224390       10/04/10 12:28:39
    21   0.96806    17593.75       11    0.96897    0.00043        391
master set rendezvous nps =   4324390       10/04/10 12:29:28
master set rendezvous nps =   4424365       10/04/10 12:30:18
    22   0.97031    19023.68       12    0.96908    0.00040        392
master set rendezvous nps =   4524365       10/04/10 12:31:08
master set rendezvous nps =   4624365       10/04/10 12:31:58
master set rendezvous nps =   4625041       10/04/10 12:32:47
    23   0.97033    21275.59       13    0.96918    0.00038        376
master set rendezvous nps =   4725041       10/04/10 12:32:54
master set rendezvous nps =   4824438       10/04/10 12:33:44
    24   0.97150    22838.22       14    0.96935    0.00039        330
master set rendezvous nps =   4924438       10/04/10 12:34:33
master set rendezvous nps =   5024438       10/04/10 12:35:23
master set rendezvous nps =   5024757       10/04/10 12:36:13
    25   0.96858    25289.12       15    0.96930    0.00037        330
master set rendezvous nps =   5124757       10/04/10 12:36:19
master set rendezvous nps =   5224167       10/04/10 12:37:11
    26   0.97301    26984.38       16    0.96953    0.00042        240
master set rendezvous nps =   5324167       10/04/10 12:38:01
master set rendezvous nps =   5424167       10/04/10 12:38:52
master set rendezvous nps =   5424662       10/04/10 12:39:42
    27   0.96821    29634.27       17    0.96945    0.00040        234
master set rendezvous nps =   5524662       10/04/10 12:39:48
master set rendezvous nps =   5623705       10/04/10 12:40:40
    28   0.97097    31462.01       18    0.96953    0.00039        234
master set rendezvous nps =   5723705       10/04/10 12:41:29
master set rendezvous nps =   5823705       10/04/10 12:42:21
master set rendezvous nps =   5824213       10/04/10 12:43:10
    29   0.97080    34310.12       19    0.96960    0.00037        229
master set rendezvous nps =   5924213       10/04/10 12:43:16
master set rendezvous nps =   6023837       10/04/10 12:44:06
    30   0.96899    36270.09       20    0.96957    0.00035        237
master set rendezvous nps =   6123837       10/04/10 12:44:55
master set rendezvous nps =   6223226       10/04/10 12:45:45
    31   0.96712    38296.18       21    0.96945    0.00036        220
master set rendezvous nps =   6323226       10/04/10 12:46:34
master set rendezvous nps =   6422930       10/04/10 12:47:24
    32   0.97057    40388.48       22    0.96951    0.00034        223
master set rendezvous nps =   6522930       10/04/10 12:48:13
master set rendezvous nps =   6622930       10/04/10 12:49:03
master set rendezvous nps =   6623674       10/04/10 12:49:53
    33   0.97024    43633.79       23    0.96954    0.00033        221
master set rendezvous nps =   6723674       10/04/10 12:49:59
master set rendezvous nps =   6823527       10/04/10 12:50:49
    34   0.97035    45858.56       24    0.96957    0.00032        226
master set rendezvous nps =   6923527       10/04/10 12:51:38
master set rendezvous nps =   7023527       10/04/10 12:52:28
master set rendezvous nps =   7023839       10/04/10 12:53:17
    35   0.97254    49302.54       25    0.96969    0.00033        197
master set rendezvous nps =   7123839       10/04/10 12:53:23
master set rendezvous nps =   7223839       10/04/10 12:54:15
master set rendezvous nps =   7224634       10/04/10 12:55:04
    36   0.96982    52845.60       26    0.96969    0.00031        198
master set rendezvous nps =   7324634       10/04/10 12:55:10
master set rendezvous nps =   7424242       10/04/10 12:56:00
    37   0.97139    55268.89       27    0.96976    0.00031        195
master set rendezvous nps =   7524242       10/04/10 12:56:49
"