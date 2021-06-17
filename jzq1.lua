local jzq1 = {}

function jzq1.openLayer()
  if jzq.layer2 then
    jzq.layer2:removeSelf()
    jzq.layer2 = nil
    --ArenaChampionCurRankPanel = nil
    --require("game.arena.view.champion.arena_champion_cur_rank_panel")
    message("删除页面")
  else
    message("创建页面")
    jzq.layer2 = cc.LayerColor:create(cc.c4b(0,0,0,0))
    jzq.layer:addChild(jzq.layer2)
  end
end

function jzq1.openView(status)
  if status then
		if jzq.openSomeView == nil then
      local data =  {
    }
			jzq.openSomeView = BattleMvpView.New(data)
      jzq.openSomeView:open()
		end
	
	else
		if jzq.openSomeView then
			jzq.openSomeView:close()
			jzq.openSomeView = nil
		end
	end
end

function jzq1.test()
      jzq.hot_fix_game()
end

return jzq1

