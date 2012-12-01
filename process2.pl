
use strict;
use Template;
use Template::Directive;
use AppConfig;
my $NAME     = "tpage";

my %munis = (

    "01" =>  "Deçan",
    "02" => "Dragash",
    "03" =>  "Gjakovë",
    "04" => "Gllogovc", 
    "05" => "Gjilan", 
    "06" => "Istog", 
    "07" => "Kaçanik",
    "08" => "Kamenicë", 	
    "09" => "Klinë", 
    10 => "Fushë Kosovë",
    14 => "Mitrovicë",	
    15 => "Novobërdë",
    16 => "Obiliq",
    17 => "Rahovec" ,
    18 => "Pejë",
    19 => "Podujevë",
    24 =>  "Shtime",
    27 => "Viti",
    11 =>"Albanik",
    12 => "Lipjan",
    13 => "Malishevë",
    20 => "Prishtinë",
    21 => "Prizren",
    22 =>  "Skënderaj",
    23  => "Shtërpcë",
    25 => "Suharekë",
    26 => "Ferizaj",
    28 => "Vushtrri",
    29 => "Zubin Potok",
    30 => "Zveçan",
    # 31 => "31?",
    # 32 => "???",
    # 33 => "???33",
    # 34 => "???2",
    # 35 => "???35",
    # 36 => "???36",
    # 37 => "???3",
    #"00" =>  "WHAT?",
);

my %featurecodes = (
    "PPL" => "Fshati",
);

my %featurecodes2 = (
    "PPL" => "fshat",
);


my %country = (
    "AL" => "Albania",
    "MK" => "macedonia",
    "KV" => "Kosovo",
    "RI" => "Serbia",
    "MJ" => "MJ?",
    "AL,KV" => "Albania/Kosovo",
    "KV,RI" => "KV,RI",
    "AL,KV,MJ" => "Albania/Kosovo/MJ",
    "BK,HR,KV,MJ,MK,RI,SI" => "BK,HR,KV,MJ,MK,RI,SI",
    );

my %country2 = (
    "KV" => "Kosovës",
    "AL" => "Albania",
    "MJ" => "MJ?",
    "KV,RI" => "KV,Serbia",
    "MK" => "macedonia",
    "RI" => "Serbia",
    "AL,KV" => "Albania/Kosovo",
    "AL,KV,MJ" => "Albania/Kosovo",
    "BK,HR,KV,MJ,MK,RI,SI" => "BK,HR,KV,MJ,MK,RI,SI",
    );

mkdir "out" unless -d "out";

my $template = Template->new({});
open IN,"kv.txt";
my %ufi;
while (<IN>) {

    my ($RC,
	$UFI,
	$UNI,
	$LAT,
	$LONG,
	$DMS_LAT,
	$DMS_LONG,
	$MGRS,
	$JOG,
	$FC,
	$DSG,
	$PC,
	$CC1,
	$ADM1,
	$POP,
	$ELEV,
	$CC2,
	$NT,
	$LC,
	$SHORT_FORM,
	$GENERIC,
	$SORT_NAME_RO,
	$FULL_NAME_RO,
	$FULL_NAME_ND_RO,
	$SORT_NAME_RG,
	$FULL_NAME_RG,
	$FULL_NAME_ND_RG,
	$NOTE,
	$MODIFY_DATE)
    = split /\t/,$_;
    next if $RC eq "RC";
    
    my $country = $country{$CC1} || die "$CC1";
    my $country2 = $country2{$CC1} || die "$CC1";
    my $name = $FULL_NAME_RO;
    
    my $data= {
	geoname => $UFI, 
	name => $FULL_NAME_RO,
	altname => $FULL_NAME_ND_RO, 
	lat => $LAT, 
	long => $LONG,
	countrycode => $CC1,
	country => $country,
	country2 => $country2,
	municipality => $munis{$ADM1},
	elevation  =>$ELEV, 


	RC => $RC,
	UFI =>$UFI,
	UNI =>$UNI,
	DMS_LAT=>$DMS_LAT,
	DMS_LONG=>$DMS_LONG,
	MGRS=>	$MGRS,
	JOG=>	$JOG,
	FC=>	$FC,
	DSG=>	$DSG,
	PC=>	$PC,
	ADM1=>	$ADM1,
	CC2=>	$CC2,
	NT=>	$NT,
	LC=>	$LC,
	SHORT_FORM=>	$SHORT_FORM,
	GENERIC=>	$GENERIC,
	SORT_NAME_RO=>	$SORT_NAME_RO,
	FULL_NAME_RO=>	$FULL_NAME_RO,
	FULL_NAME_ND_RO=>	$FULL_NAME_ND_RO,
	SORT_NAME_RG=>	$SORT_NAME_RG,
	FULL_NAME_RG=>	$FULL_NAME_RG,
	FULL_NAME_ND_RG=>	$FULL_NAME_ND_RG,
	NOTE=>	$NOTE,
    };
    
    if ($POP ne "0" ) 
    {
#	warn "$name $population";
	$data->{population} =$POP;
    };
    
    my $id=$UFI.$UNI;
    die "$UFI exists for $LC" if exists($ufi{$id}{$LC});
    $ufi{$id}{$LC}=$data;

}

foreach my $ufi (keys %ufi) {
    my $data=$ufi{$ufi};
    my $name=$ufi{$ufi}{"sqi"}{name};
    $template->process("sq2.tt",
		       $data, 
		       "out/$name.wiki"
	) || die $template->error(), "\n";
}

close IN;
