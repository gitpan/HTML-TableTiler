# This file uses the "Perlish" coding style
# please read http://perl.4pro.net/perlish_coding_style.html

; use ExtUtils::MakeMaker

; my $dist =  'HTML::TableTiler'
; my $vers = '1.19'

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


__END__

Note: While I did removed the "phone home opt-out only logic" from all my distributions since 2004-24-06, the related ratings have not been removed so far. Sorry for the inconvenience.

Domizio Demichelis
