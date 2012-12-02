for my $lang (qw
	      [
	       deu
	       eng
	       hrv
	       mkd
	       slv 
	       sqi 
	       srb 
	       srp 
	       srr 
	       std 
	       tur
]) {
    for my $nt (qw(
C  
D	
DS	
N 
NS 	
V 	
VS  
  ) )  {
	for my $f (qw(name )  )  {
	    my $field= "${lang}.${nt}.${f}";
	    my $field2= "${lang}_${nt}_${f}";
	    print  "[% IF $field -%]\n";
	    print  "| $field2 = [% $field %]\n";
	    print  "[% END -%]\n";
	}

	for my $f (qw(  NAME_SHORT_FORM  NAME_GENERIC   NAME_SORT_NAME_RO FULL_NAME_RO  FULL_NAME_ND_RO  SORT_NAME_RG  FULL_NAME_RG  FULL_NAME_ND_RG)  )  {
	    my $field= "${lang}.${nt}.${f}";
	    my $field2= "${lang}_${nt}_${f}";
	    print  "[% IF $field -%]\n";
	    print  "| $field2 = [% $field.join(",") %]\n";
	    print  "[% END -%]\n";
	}

	
    }
}
