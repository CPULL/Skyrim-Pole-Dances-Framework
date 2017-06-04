Scriptname spdPoleDances Extends Quest

; function to set/delete a pole (as Static object)


; Hooks (global and per-thread)


spdRegistry registry

Function doInit()
	; if currentV != getVersion do update
	
	currentVersion = getVersion()
endFunction

spdThread Function start(...)
; Start by just an actor
; Actor and length
; actor and pole
; actor lenght and pole
; sequence of dances
; Hooks
; Starting pose?
endFunction


int currentVersion

int Function getVersion()
	return 1
endFunction
