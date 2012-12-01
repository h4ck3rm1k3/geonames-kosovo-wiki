
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
    "XK" => "Kosovës",
    );

my %country2 = (
    "XK" => "Kosovës",
    );

mkdir "out" unless -d "out";

my $template = Template->new({});
open IN,"XK.txt";
while (<IN>) {
    my ($geonameid, #         : integer id of record in geonames database
    $name, #              : name of geographical point (utf8) varchar(200)
    $asciiname , #         : name of geographical point in plain ascii characters, varchar(200)
    $alternatenames, #    : alternatenames, comma separated varchar(5000)
    $latitude, #          : latitude in decimal degrees (wgs84)
    $longitude, #         : longitude in decimal degrees (wgs84)
    $featureclass,#     : see http://www.geonames.org/export/codes.html, char(1)
    $featurecode, #      : see http://www.geonames.org/export/codes.html, varchar(10)
    $countrycode, #      : ISO-3166 2-letter country code, 2 characters
    $cc2, #               : alternate country codes, comma separated, ISO-3166 2-letter country code, 60 characters
    $admin1code, #       : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code; varchar(20)
    $admin2code, #       : code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80) 
    $admin3code, #       : code for third level administrative division, varchar(20)
    $admin4code, #       : code for fourth level administrative division, varchar(20)
    $population, #        : bigint (8 byte int) 
    $elevation, #         : in meters, integer
    $dem, #               : digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
    $timezone,    #      : the timezone id (see file timeZone.txt) varchar(40)
    $modificationdate) # : date of last modification in yyyy-MM-dd format
    = split /\t/,$_;
    next unless $featureclass eq "P";
    next unless $featurecode eq "PPL";

    warn  "Muni:$admin1code unknown for $name " unless     exists($munis{$admin1code});
    next unless exists($munis{$admin1code});

	
#    warn "processing $name in 1:$admin1code 2:$admin2code 3:$admin3code 4:$admin4code of type: $featureclass  type2: $featurecode  
#$countrycode
#";
    $template->process("sq.tt",
		       {
			   geoname => $geonameid, 
			   name => $name,
			   asciiname =>$asciiname , 
			   altname => $alternatenames, 
			   lat => $latitude, 
			   long => $longitude,
			   featureclass => $featureclass,
			   featurecode => $featurecode,
			   typename => $featurecodes{$featurecode},
			   countrycode => $countrycode,
			   country => $country{$countrycode},
			   country2 => $country2{$countrycode},
			   cc2=> $cc2,
			   admin1code => $admin1code,
			   municipality => $munis{$admin1code},
			   admin2code =>$admin2code,
			   admin3code =>$admin3code, 
			   admin4code => $admin4code,
			   population =>$population, 
			   elevation  =>$elevation, 
			   dem => $dem, 
		       }, 
"out/$name.wiki"
	);   
}

close IN;
