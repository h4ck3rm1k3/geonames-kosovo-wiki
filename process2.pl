use strict;
use warnings;
use Template;
use Template::Directive;

use Data::Dumper;

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

#see http://www.geonames.org/export/codes.html
my %typenames = (
    
    A => {
	ADM1 =>	236,
	ADMDH =>	1,
	PCLH	=> 12,
	PCLI	=> 13,
    },
    
    H	=> {
	LK =>	30,
	MRSH =>	2,
	RSV =>	1,
	RVN =>	5,
	SPNG =>	136,
	STM =>	508,
	STMI =>	124,
    },
    
    L	=> {
	AREA =>	33,
	CLG  => 1,
	FLD =>	14,
	LCTY =>	601,
	RGN  =>	29,
    },

    P=>	{
	PPL	=> "Fshat",
	PPLA	=> 178, # seat of a first-order administrative division
	PPLC	=> 5, # capital of a political entity	
	PPLH	=> 2, # historical populated place
	PPLL	=> "Fshat Vogel",
	PPLX	=> 7, #Section of populated place
    },

    R =>	{
	TNLRR	=> 1
    },
    
    S	=> {
	AGRF	=> 1,
	AIRF	=> 4,
	BDG	=> 7,
	CAVE	=> 10,
	CH=> 	8,
	CMTY=> 	2,
	EST=> 	1,
	FRM=> 	5,
	FT=> 	1,
	GRVE=> 	1,
	HTL=> 	3,
	HUT=> 	9,
	HUTS=> 	64,
	MFG=> 	1,
	MLWTR=> 	6,
	MN=> 	1,
	MNMT=> 	1,
	MSTY=> 	9,
	PS=> 	2,
	PSH=> 	3,
	PSTB=> 	2,
	PSTP=> 	82,
	RSTN=> 	156,
	RUIN=> 	2,
	SHPF=> 	15
    },
    
    T    => {
	CLF=> 	49,
	DPR=> 	1,
	GRGE=> 	15,
	HDLD=> 	1,
	HLL=> 	427,
	HLLS=> 	15,
	KRST=> 	1,
	MND=> 	3,
	MT=> 	835,
	MTS=> 	70,
	PASS=> 	58,
	PK=> 	174,
	PLN=> 	14,
	RDGE=> 	152,
	RK=> 	13,
	RKS=> 	1,
	SDL=> 	4,
	SINK=> 	2,
	SLP=> 	147,
	SPUR=> 	157,
	VAL	=>29
    },
    
    V	=> {
	FRST	=> 3,
	MDW	=> 13
    }
    
    );

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

    $LC=	$LC || "std";

    my $typename = $typenames{$FC}{$DSG} || die "no typename $FC $DSG";
    next if $typename =~ /^\d/;
#    warn $typename unless  $typename =~ /^[a-zA-ZŽ]/;
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
	typename  =>$typename, 


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
	LC=>	$LC ,
	SHORT_FORM=>	[$SHORT_FORM],
	GENERIC=>	[$GENERIC],
	SORT_NAME_RO=>	[$SORT_NAME_RO],
	FULL_NAME_RO=>	[$FULL_NAME_RO],
	FULL_NAME_ND_RO=>	[$FULL_NAME_ND_RO],
	SORT_NAME_RG=>	[$SORT_NAME_RG],
	FULL_NAME_RG=>	[$FULL_NAME_RG],
	FULL_NAME_ND_RG=>	[$FULL_NAME_ND_RG],
	NOTE=>	$NOTE,
    };

    my $names = {
	SHORT_FORM=>	$SHORT_FORM,
	GENERIC=>	$GENERIC,
	SORT_NAME_RO=>	$SORT_NAME_RO,
	FULL_NAME_RO=>	$FULL_NAME_RO,
	FULL_NAME_ND_RO=>	$FULL_NAME_ND_RO,
	SORT_NAME_RG=>	$SORT_NAME_RG,
	FULL_NAME_RG=>	$FULL_NAME_RG,
	FULL_NAME_ND_RG=>	$FULL_NAME_ND_RG,
    };
    
    if ($POP ne "0" ) 
    {
#	warn "$name $population";
	$data->{population} =$POP;
    };
    
    my $id=$UFI; # unique feature id
    #die "$UFI exists for $LC and $NT" 
    if (exists($ufi{$id}{$LC}{$NT}))
    {
	#append the names
	for my $x (qw(SHORT_FORM	GENERIC	SORT_NAME_RO	FULL_NAME_RO	FULL_NAME_ND_RO	SORT_NAME_RG	FULL_NAME_RG	FULL_NAME_ND_RG))
	{
	    push @{$ufi{$id}{$LC}{$NT}{$x}},$names->{$x}; # name type as well
	}
    }
    else
    {
	$ufi{$id}{$LC}{$NT}=$data; # name type as well
    }

}

sub findname 
{
    my $x=shift;
    for my $lang ("sqi", "std", "srp")    {
	for my $nt ("N", "D") {
	    return $x->{$lang}{$nt}{"name"} if exists($x->{$lang}{$nt}{"name"});
	}
    }
    die "no data:" . Dumper($x);

}

sub find
{
    my $x=shift;
    my $n=shift;
    for my $lang ("sqi", "std", "srp")    {
	for my $nt ("N", "D") {
	    return $x->{$lang}{$nt}{$n} if exists($x->{$lang}{$nt}{$n});
	}
    }
    die "no data for $n in:" . Dumper($x);

}

foreach my $ufi (keys %ufi) {
    
    my $data=$ufi{$ufi};
    my $name=findname($ufi{$ufi});
#    warn "$name";
    next unless $name =~ /\w+/;

    # calculate standard names
    for my $n (qw(country2 name country municipality population lat long elevation typename)) {
	$data->{'std'}{'STD'}{$n}=find($data,$n);
    }

    $template->process("sq2.tt",
		       $data, 
		       "out/$name.wiki"
	) || die $template->error(), "\n";
}

close IN;
