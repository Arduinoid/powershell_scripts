(Get-ADObject "cn=Directory service, cn=Windows NT, cn=Services,$(Get-ADRootDSE | select -ExpandProperty ConfigurationNamingContext)" -Properties tombstonelifetime).tombstonelifetime
