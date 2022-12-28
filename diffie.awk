# awk program to eliminate diffie-hellman-group-exchange-sha1
# awk -f diffie.awk < openssh.config > openssh.new
$1 !~ /^KexAlgorithms/ { printf("%s\n",$0) }
$1 ~ /^KexAlgorithms/ { x = split($2,a,",") 
                         if (x > 0 ) {
                            printf("KexAlgorithms ")
                            y = 1
                            while ( y < x ) {
                              if ( a[y] != "diffie-hellman-group-exchange-sha1" ) {
                                printf("%s,",a[y]);
                              }
                              y++
                            }
                            printf("%s\n",a[y])
                         }
                       }
