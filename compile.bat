@echo off
make
if %errorlevel%==0 ( 
	if exist mysplinterpreter (
		if exist mysplinterpreter.exe ( 
			del mysplinterpreter.exe
		)
		rename mysplinterpreter mysplinterpreter.exe
	)
)