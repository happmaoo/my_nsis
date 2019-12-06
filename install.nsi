; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply 
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there. 

;--------------------------------

; The name of the installer
Name "install"
caption "William soft installation 20190111"
Icon install.ico



; The file to write
OutFile "install.exe"

; The default installation directory
;InstallDir $DESKTOP

; Request application privileges for Windows Vista
RequestExecutionLevel admin
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "StrFunc.nsh"
${StrTrimNewLines} ; Tell StrFunc.nsh to define this function for us
${StrRep} ;'Declare' functions used in StrFunc.nsh


!define my_desktop $desktop
!define my_temp $temp
!define my_appdata $appdata
!define my_profile $profile
;ShowInstDetails show

;---------------------------------------Function StrContains begin-------------------------------------------------------------
; StrContains
; This function does a case sensitive searches for an occurrence of a substring in a string.
; It returns the substring if it is found.
; Otherwise it returns null("").
; Written by kenglish_hi
; Adapted from StrReplace written by dandaman32


Var STR_HAYSTACK
Var STR_NEEDLE
Var STR_CONTAINS_VAR_1
Var STR_CONTAINS_VAR_2
Var STR_CONTAINS_VAR_3
Var STR_CONTAINS_VAR_4
Var STR_RETURN_VAR

Function StrContains
  Exch $STR_NEEDLE
  Exch 1
  Exch $STR_HAYSTACK
  ; Uncomment to debug
  ;MessageBox MB_OK 'STR_NEEDLE = $STR_NEEDLE STR_HAYSTACK = $STR_HAYSTACK '
    StrCpy $STR_RETURN_VAR ""
    StrCpy $STR_CONTAINS_VAR_1 -1
    StrLen $STR_CONTAINS_VAR_2 $STR_NEEDLE
    StrLen $STR_CONTAINS_VAR_4 $STR_HAYSTACK
    loop:
      IntOp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_1 + 1
      StrCpy $STR_CONTAINS_VAR_3 $STR_HAYSTACK $STR_CONTAINS_VAR_2 $STR_CONTAINS_VAR_1
      StrCmp $STR_CONTAINS_VAR_3 $STR_NEEDLE found
      StrCmp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_4 done
      Goto loop
    found:
      StrCpy $STR_RETURN_VAR $STR_NEEDLE
      Goto done
    done:
   Pop $STR_NEEDLE ;Prevent "invalid opcode" errors and keep the
   Exch $STR_RETURN_VAR
FunctionEnd

!macro _StrContainsConstructor OUT NEEDLE HAYSTACK
  Push `${HAYSTACK}`
  Push `${NEEDLE}`
  Call StrContains
  Pop `${OUT}`
!macroend

!define StrContains '!insertmacro "_StrContainsConstructor"'

;---------------------------------------Function StrContains end-------------------------------------------------------------

;--------------------------------

; Pages


;--------------------------------

var Str_all
var str_target
var str_path_var
var str_result

function find_replace_path_fun
Pop $str_all
Pop $str_target
Pop $str_path_var

;MessageBox MB_OK "all:$str_all target:$str_target path_var:$str_path_var"

${StrContains} $0 "$str_target" $str_all
StrCmp $0 "" notfound
  ;MessageBox MB_OK 'Found string $0'
  ${StrRep} $R1 "$str_all" "$str_target" "$str_path_var"
  Goto done
notfound:
  ;MessageBox MB_OK 'Did not find string'
done:
     ;MessageBox MB_OK 'here is done $R1'
     ${If} $R1 == ""
       ;MessageBox MB_OK "$R1 = empty"
       StrCpy $str_result $str_all
     ${Else}
       StrCpy $str_result $R1
     ${EndIf}
     Pop $str_result
functionend

!macro find_replace_path Str_all str_target str_path_var
	push ${Str_all}
        push ${str_target}
        push ${str_path_var}
	Call find_replace_path_fun
        Pop $str_result
!macroend

;--------------------------------------------






Function .onInit



functionend







var line1
var line2
var line3

Section "" ;No components page, name is not important



SetOutPath $TEMP
File install.nsi

SetOutPath $EXEDIR

FileOpen $3 "install.txt" r
FileRead $3 $4
${StrTrimNewLines} $4 $4
FileRead $3 $5
${StrTrimNewLines} $5 $5
FileRead $3 $6
${StrTrimNewLines} $6 $6
FileClose $3
DetailPrint "Line 1=$4"
DetailPrint "Line 2=$5"
StrCpy $line1 $4
StrCpy $line2 $5
StrCpy $line3 $6


;${StrRep} $R1 $4 "my_desktop" ${my_desktop}
;MessageBox MB_OK ${my_profile}

!insertmacro find_replace_path "${my_desktop}" "my_desktop" "$line2"
!insertmacro find_replace_path "${my_temp}" "my_temp" "$line2"
!insertmacro find_replace_path "${my_appdata}" "my_appdata" "$line2"
!insertmacro find_replace_path "${my_profile}" "my_profile" "$line2"
;MessageBox MB_OK $str_result

CopyFiles $line1 $str_result
MessageBox MB_OK "Copy from:$\r$\n $line1 $\r$\n to $\r$\n $str_result"

;-------------------------------regedit---------------------------------
IfFileExists $EXEDIR\install.reg file_found file_not_found
file_found:
exec '"regedit" install.reg'
goto end_of_test ;<== important for not continuing on the else branch
file_not_found:
DetailPrint "install.reg doesn't exist, skip."
end_of_test:



SectionEnd ; end the section






