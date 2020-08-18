Problem 6
---------

    ## transactions as itemMatrix in sparse format with
    ##  9835 rows (elements/itemsets/transactions) and
    ##  169 columns (items) and a density of 0.02609146 
    ## 
    ## most frequent items:
    ##       whole milk other vegetables       rolls/buns             soda 
    ##             2513             1903             1809             1715 
    ##           yogurt          (Other) 
    ##             1372            34055 
    ## 
    ## element (itemset/transaction) length distribution:
    ## sizes
    ##    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16 
    ## 2159 1643 1299 1005  855  645  545  438  350  246  182  117   78   77   55   46 
    ##   17   18   19   20   21   22   23   24   26   27   28   29   32 
    ##   29   14   14    9   11    4    6    1    1    1    1    3    1 
    ## 
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.000   2.000   3.000   4.409   6.000  32.000 
    ## 
    ## includes extended item information - examples:
    ##             labels
    ## 1 abrasive cleaner
    ## 2 artif. sweetener
    ## 3   baby cosmetics

For reading in the file, we used the sep=‘,’ parameter. Looking at the
file itself, we can see that there are a total of 9835 transactions in
our data. Of those transactions, 2159 transactions have an item basket
of only 1 item and more than half of the transactions have 3 items or
less.

![](Problem-6-analysis_files/figure-markdown_strict/unnamed-chunk-2-1.png)

If we take a look at the item frequency distribution, we can see that
whole milk is present in a whopping 2513 number of transactions. This
makes sense as milk is a staple and has a somewhat short shelf life
which necessitates purchasing it a lot.

    ## [1] 113

We also played around with crosstable to look at the various different
combinations of items. For instance, we found that whole milk and ham
appear 113 times. After this, we decided to play around with the item
rules.

    ##     lhs                   rhs          support    confidence coverage  lift    
    ## [1] {yogurt}           => {whole milk} 0.05602440 0.4016035  0.1395018 1.571735
    ## [2] {rolls/buns}       => {whole milk} 0.05663447 0.3079049  0.1839349 1.205032
    ## [3] {other vegetables} => {whole milk} 0.07483477 0.3867578  0.1934926 1.513634
    ##     count
    ## [1] 551  
    ## [2] 557  
    ## [3] 736

Our first rule was looking at a support values  &gt; = 0.05 which
essentially stands for the percentage of occurences that this happens in
the entire dataset and a confidence levels  &gt; = 0.3 which is
basically how likely this interaction will happen. As we can see, this
criteria gave us 3 rules. Let’s use rule 1 as an example on how to
interpret thse rules. Basically if a person buys yogurt, there is about
a 40.16% chance that they also buy whole milk. which is represented in
the following plot.

![](Problem-6-analysis_files/figure-markdown_strict/unnamed-chunk-6-1.png)

This plot shows that yogurt tends to be purchased with whole milk along
with other vegetables and roll/buns. To find other interesting item
combinations, we continued to play around with the support and
confidence parameters.

    ##      lhs                     rhs                support    confidence
    ## [1]  {whipped/sour cream} => {whole milk}       0.03223183 0.4496454 
    ## [2]  {pip fruit}          => {whole milk}       0.03009659 0.3978495 
    ## [3]  {pastry}             => {whole milk}       0.03324860 0.3737143 
    ## [4]  {citrus fruit}       => {whole milk}       0.03050330 0.3685504 
    ## [5]  {sausage}            => {rolls/buns}       0.03060498 0.3257576 
    ## [6]  {bottled water}      => {whole milk}       0.03436706 0.3109476 
    ## [7]  {tropical fruit}     => {other vegetables} 0.03589222 0.3420543 
    ## [8]  {tropical fruit}     => {whole milk}       0.04229792 0.4031008 
    ## [9]  {root vegetables}    => {other vegetables} 0.04738180 0.4347015 
    ## [10] {root vegetables}    => {whole milk}       0.04890696 0.4486940 
    ## [11] {yogurt}             => {other vegetables} 0.04341637 0.3112245 
    ## [12] {yogurt}             => {whole milk}       0.05602440 0.4016035 
    ## [13] {rolls/buns}         => {whole milk}       0.05663447 0.3079049 
    ## [14] {other vegetables}   => {whole milk}       0.07483477 0.3867578 
    ##      coverage   lift     count
    ## [1]  0.07168277 1.759754 317  
    ## [2]  0.07564820 1.557043 296  
    ## [3]  0.08896797 1.462587 327  
    ## [4]  0.08276563 1.442377 300  
    ## [5]  0.09395018 1.771048 301  
    ## [6]  0.11052364 1.216940 338  
    ## [7]  0.10493137 1.767790 353  
    ## [8]  0.10493137 1.577595 416  
    ## [9]  0.10899847 2.246605 466  
    ## [10] 0.10899847 1.756031 481  
    ## [11] 0.13950178 1.608457 427  
    ## [12] 0.13950178 1.571735 551  
    ## [13] 0.18393493 1.205032 557  
    ## [14] 0.19349263 1.513634 736

![](Problem-6-analysis_files/figure-markdown_strict/unnamed-chunk-9-1.png)
We kept confidence constant at 0.3 and decreased support to 0.03 for
this rule. We found 14 rules associated with this criteria. As expected,
whole milk seems to dominate most of the items as it is involved in a
lot of purchases but there were some combinations like sausage to
roll/buns that managed to come through.

    ##     lhs                                        rhs          support   
    ## [1] {root vegetables,tropical fruit,yogurt} => {whole milk} 0.00569395
    ##     confidence coverage    lift     count
    ## [1] 0.7        0.008134215 2.739554 56

![](Problem-6-analysis_files/figure-markdown_strict/unnamed-chunk-12-1.png)

Seeing as we got more rules from decreasing support, we wanted to
decrease support even further while tightening up confidence to see what
would happen. This led us to trying out 0.005 and 0.7 for those
respective parameters. The results we obtained are shown above. From our
experimentation here, we note that increasing confidence as expected
does decrease the number of item rules while decreasing support levels
increases them.

    ##      lhs                        rhs                    support confidence    coverage     lift count
    ## [1]  {herbs,                                                                                        
    ##       tropical fruit}        => {whole milk}       0.002338587  0.8214286 0.002846975 3.214783    23
    ## [2]  {herbs,                                                                                        
    ##       rolls/buns}            => {whole milk}       0.002440264  0.8000000 0.003050330 3.130919    24
    ## [3]  {curd,                                                                                         
    ##       hamburger meat}        => {whole milk}       0.002541942  0.8064516 0.003152008 3.156169    25
    ## [4]  {grapes,                                                                                       
    ##       tropical fruit,                                                                               
    ##       whole milk}            => {other vegetables} 0.002033554  0.8000000 0.002541942 4.134524    20
    ## [5]  {curd,                                                                                         
    ##       domestic eggs,                                                                                
    ##       other vegetables}      => {whole milk}       0.002846975  0.8235294 0.003457041 3.223005    28
    ## [6]  {butter,                                                                                       
    ##       other vegetables,                                                                             
    ##       pork}                  => {whole milk}       0.002236909  0.8461538 0.002643620 3.311549    22
    ## [7]  {fruit/vegetable juice,                                                                        
    ##       other vegetables,                                                                             
    ##       root vegetables,                                                                              
    ##       yogurt}                => {whole milk}       0.002033554  0.8333333 0.002440264 3.261374    20
    ## [8]  {fruit/vegetable juice,                                                                        
    ##       root vegetables,                                                                              
    ##       whole milk,                                                                                   
    ##       yogurt}                => {other vegetables} 0.002033554  0.8000000 0.002541942 4.134524    20
    ## [9]  {citrus fruit,                                                                                 
    ##       root vegetables,                                                                              
    ##       tropical fruit,                                                                               
    ##       whole milk}            => {other vegetables} 0.003152008  0.8857143 0.003558719 4.577509    31
    ## [10] {citrus fruit,                                                                                 
    ##       other vegetables,                                                                             
    ##       root vegetables,                                                                              
    ##       yogurt}                => {whole milk}       0.002338587  0.8214286 0.002846975 3.214783    23
    ## [11] {rolls/buns,                                                                                   
    ##       root vegetables,                                                                              
    ##       tropical fruit,                                                                               
    ##       yogurt}                => {whole milk}       0.002236909  0.8148148 0.002745297 3.188899    22

![](Problem-6-analysis_files/figure-markdown_strict/unnamed-chunk-15-1.png)

To further confirm our suspicions, for our final tuning we changed the
parameter to 0.002 support and 0.8 confidence. This resulted in a plot
for 11 rules as seen above.
