# This file uses the "Perlish" coding style
# please read http://perl.4pro.net/perlish_coding_style.html

; use ExtUtils::MakeMaker

; my $dist =  'HTML::TableTiler'
; my $vers = '1.18'

; WriteMakefile
   ( NAME           => $dist
   , VERSION        => $vers
   , ($] ge '5.005')
     ? ( AUTHOR     => 'Domizio Demichelis - perl.4pro.net'
       , ABSTRACT   => 'Easily generates graphic styled HTML tables'
       )
     : ()
   , PREREQ_PM	     => { 'HTML::PullParser' => '1.0'
                       , 'IO::Util'         => '1.2'
                       }
   )


; 1
