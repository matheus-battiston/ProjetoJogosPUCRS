extends Node

# Variáveis que você deseja persistir
var item_unlocked : bool = false
var multiplier = 1.0
var level = 1

func unlock():
	item_unlocked = true

func avancLevel():
	level = level + 1
	
func resetLevels():
	level = 1

func getItemUnlocked():
	return item_unlocked

func addMultiplier():
	multiplier = multiplier + 0.3
	
func startNewGamePlus():
	addMultiplier()
	unlock()
