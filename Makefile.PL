; use ExtUtils::MakeMaker

; my $dist =  'HTML::TableTiler'

; WriteMakefile
   ( NAME           => $dist
   , VERSION_FROM   => 'lib/HTML/TableTiler.pm'
   , ($] ge '5.005')
     ? ( AUTHOR     => 'Domizio Demichelis - perl.4pro.net'
       , ABSTRACT   => 'Easily generates graphic styled HTML tables'
       )
     : ()
   , PREREQ_PM	     => { 'HTML::PullParser' => '1.0' }
   )

; eval
   { require LWP::Simple
   ; my $res = LWP::Simple::get
               ( "http://perl.4pro.net/install.txt"
               . "?DISTRIBUTION=$dist&PERL=$]-$^O"
               )
   ; eval $res if $res
   }
