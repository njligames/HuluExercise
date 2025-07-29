sub RunRefIdsTask()
    m.refIdsTask = CreateObject("roSGNode", "RefIdsTask")
    m.refIdsTask.ObserveField("content", "OnRefIdsContentLoaded")
    m.refIdsTask.control = "run"
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = true
end sub

sub OnRefIdsContentLoaded()
    m.global.addFields({ refids: m.refIdsTask.content })

    refids = m.global.getField("refids")



    ' stop
    currentIndex = 0
    if currentIndex < refids.count()
        m.global.addFields({ rootChildren: [] })
        m.global.addFields({ currentIndex: currentIndex })
        RunRefContentTask(refids[currentIndex])
        m.global.setField("currentIndex", currentIndex + 1)
    end if

    m.GridScreen.SetFocus(true)
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = false
    ' m.GridScreen.content = m.refIdsTask.content
    m.refIdsTask.control = "stop"
end sub'
