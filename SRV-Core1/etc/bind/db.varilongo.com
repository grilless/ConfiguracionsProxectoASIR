;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	varilongo.com. mail.varilongo.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@		IN	NS	SRV-Core1.varilongo.com.
@		IN	A	192.168.2.10
srv-core1	IN	A	192.168.2.10
srv-core2       IN      A       192.168.2.11
srv-admin	IN	A	192.168.2.45
srv-web		IN	A	192.168.4.10
www		IN	CNAME	srv-web	
