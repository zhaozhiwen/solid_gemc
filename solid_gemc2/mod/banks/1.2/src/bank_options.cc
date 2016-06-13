// gemc headers
#include "options.h"

void goptions::setGoptions()
{
	// Initialize all the options in the map<string, aopt>
	//
	// The "string" of the pair in the map is the argument name: -"name"=
	// args = the string type argument
	// arg  = the numeric type argument
	// help = Long explanation.
	// name = Short description.
	// type = 1 for argumenst that are strings, 0 for numbers.
    
	
	// MySQL Database
	optMap["DBHOST"].args = "no";
	optMap["DBHOST"].help = "Selects mysql server host name.";
	optMap["DBHOST"].name = "mysql server host name";
	optMap["DBHOST"].type = 1;
	optMap["DBHOST"].ctgr = "mysql";
	
	optMap["DATABASE"].args = "no";
	optMap["DATABASE"].help = "Selects mysql Database.";
	optMap["DATABASE"].name = "mysql Database";
	optMap["DATABASE"].type = 1;
	optMap["DATABASE"].ctgr = "mysql";
	
	optMap["DBUSER"].args = "gemc";
	optMap["DBUSER"].help = "Select mysql user name";
	optMap["DBUSER"].name = "Select mysql user name";
	optMap["DBUSER"].type = 1;
	optMap["DBUSER"].ctgr = "mysql";
	
	optMap["DBPSWD"].args = "no";
	optMap["DBPSWD"].help = "mysql password";
	optMap["DBPSWD"].name = "Select mysql password";
	optMap["DBPSWD"].type = 1;
	optMap["DBPSWD"].ctgr = "mysql";
	
	optMap["DBPORT"].arg = 0;
	optMap["DBPORT"].help = "Select mysql server port.";
	optMap["DBPORT"].name = "Select mysql server port";
	optMap["DBPORT"].type = 0;
	optMap["DBPORT"].ctgr = "mysql";

	
	// Verbosity
	optMap["BANK_VERBOSITY"].arg  = 0;
	optMap["BANK_VERBOSITY"].help = "Controls Bank Log Output. 1 = some 2 = all";
	optMap["BANK_VERBOSITY"].name = "Bank Output Verbosity";
	optMap["BANK_VERBOSITY"].type = 0;
	optMap["BANK_VERBOSITY"].ctgr = "verbosity";
	
	
	optMap["WRITE_RAWS"].args = "yes";
	optMap["WRITE_RAWS"].help = "Write raw banks option: yes or no. Default: yes";
	optMap["WRITE_RAWS"].name = "Write raw banks option: yes or no. Default: yes";
	optMap["WRITE_RAWS"].type = 1;
	optMap["WRITE_RAWS"].ctgr = "io";
	
	// IO
	optMap["INPUTF"].args = "na";
	optMap["INPUTF"].help = "Input File";
	optMap["INPUTF"].name = "Input File";
	optMap["INPUTF"].type = 1;
	optMap["INPUTF"].ctgr = "io";
	
	// IO
	optMap["B"].args = "all";
	optMap["B"].help = "Bank(s) to be published";
	optMap["B"].name = "Bank(s) to be published";
	optMap["B"].type = 1;
	optMap["B"].ctgr = "io";

	optMap["ADDEVN"].arg  = 0;
	optMap["ADDEVN"].help = "Add a number to the event number: default is 0. Useful for chaining root files while keeping track of event number.";
	optMap["ADDEVN"].name = "Add a number to the event number.";
	optMap["ADDEVN"].type = 0;
	optMap["ADDEVN"].ctgr = "io";

	
	// Max Number of events
	optMap["N"].arg  = 0;
	optMap["N"].help = "Max number of events to be processed";
	optMap["N"].name = "Max number of events to be processed";
	optMap["N"].type = 1;
	optMap["N"].ctgr = "io";
	
	
}


