
#Desc:Energy is now conserved between turns.
func OnBattleStart(chara:CharaBtl):
    pass

func OnBattleEnd(chara:CharaBtl):
    pass

func OnEnterSite(chara,site):
    pass

func OnPickUp(chara):
    GlbDat.marks["en_conserved"] = true
    pass
            