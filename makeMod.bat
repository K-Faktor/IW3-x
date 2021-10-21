@echo off
set modname=Mod_Builder
set COMPILEDIR=%CD%
color 11
title "MOD BUILDER V1.0"
:MAKEOPTIONS
cls
:MAKEOPTIONS
echo -----------------------------------------------------------------
echo  Please select an option:
echo    1. Build Fast File
echo    2. Build IWD File
echo.
echo    0. Exit
echo -----------------------------------------------------------------
echo.
set /p make_option=:
set make_option=%make_option:~0,1%
if "%make_option%"=="1" goto build_ff
if "%make_option%"=="2" goto build_iwd
if "%make_option%"=="0" goto FINAL
goto :MAKEOPTIONS
:build_iwd
cls
cd
echo -----------------------------------------------------------------
echo.
echo  Building IWD'S:
del iw3x_images.iwd
del iw3x_sounds.iwd
del iw3x_weapons.iwd
7za a -r -tzip iw3x_images.iwd images
7za a -r -tzip iw3x_sounds.iwd sound
7za a -r -tzip iw3x_weapons.iwd weapons
echo Completed: %time%
echo -----------------------------------------------------------------
pause
goto :MAKEOPTIONS
:build_ff
cls
cd
echo -----------------------------------------------------------------
echo  Building mod.ff:
echo    Deleting old mod.ff file...
del mod.ff
echo    Copying rawfiles...
xcopy localizedstrings ..\..\raw\localizedstrings /SY
xcopy promod ..\..\raw\promod /SY
xcopy shock ..\..\raw\shock /SY
xcopy rumble ..\..\raw\rumble /SY
xcopy hanu ..\..\raw\hanu /SY
xcopy images ..\..\raw\images /SY
xcopy materials ..\..\raw\materials /SY
xcopy material_properties ..\..\raw\material_properties /SY
xcopy sound ..\..\raw\sound /SY
xcopy soundaliases ..\..\raw\soundaliases /SY
xcopy fx ..\..\raw\fx /SY
xcopy mp ..\..\raw\mp /SY
xcopy weapons\mp ..\..\raw\weapons\mp /SY
xcopy xanim ..\..\raw\xanim /SY
xcopy xmodel ..\..\raw\xmodel /SY
xcopy xmodelparts ..\..\raw\xmodelparts /SY
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SY
xcopy ui ..\..\raw\ui /SY
xcopy ui_mp ..\..\raw\ui_mp /SY
xcopy english ..\..\raw\english /SY
xcopy vision ..\..\raw\vision /SY
xcopy animtrees ..\..\raw\animtrees /SYI > NUL
echo    Copying source code...
xcopy maps ..\..\raw\maps /SY
xcopy promod ..\..\raw\promod /SY
xcopy promod_ruleset ..\..\raw\promod_ruleset /SY
echo    Copying MOD.CSV...
xcopy mod.csv ..\..\zone_source /SY
echo    Compiling mod...
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd %COMPILEDIR%
copy ..\..\zone\english\mod.ff
echo  New mod.ff file successfully built!
echo Completed: %time%
echo -----------------------------------------------------------------
pause
goto :MAKEOPTIONS
:FINAL