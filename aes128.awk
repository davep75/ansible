# awk program to eliminate aes128-cbc
# awk -f aes128.awk < openssh.config > openssh.new
$1 !~ /^Ciphers/ { printf("%s\n",$0) }
$1 ~ /^Ciphers/ { x = split($2,a,",") 
                         if (x > 0 ) {
                            printf("Ciphers ")
                            y = 1
                            while ( y <= x ) {
                              if ( a[y] != "aes128-cbc" ) {
                                printf("%s,",a[y]);
                              }
                              y++
                            }
                            printf("\n")
                         }
                       }
