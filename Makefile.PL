use ExtUtils::MakeMaker;

WriteMakefile
(
    NAME           => 'HTML::TableTiler',
    VERSION_FROM   => 'lib/HTML/TableTiler.pm',
 	($] ge '5.005') ? (
 	AUTHOR         => 'Domizio Demichelis <dd\@4pro.net>',
    ABSTRACT       => 'Easily generates graphic styled HTML tables',
	) : (),
    PREREQ_PM	   => { HTML::PullParser => 1.0 }
);
