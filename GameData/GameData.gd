extends Node

# Variáveis que você deseja persistir
var item_unlocked : bool = false

func unlock():
	item_unlocked = true

func getItemUnlocked():
	return item_unlocked
