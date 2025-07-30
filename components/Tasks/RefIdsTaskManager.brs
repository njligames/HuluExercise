sub RunRefIdsTask()
    m.refIdsTask = CreateObject("roSGNode", "RefIdsTask")
    m.refIdsTask.ObserveField("content", "OnRefIdsContentLoaded")
    m.refIdsTask.control = "run"
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = true
end sub

sub OnRefIdsContentLoaded()
    gridScreen = CurrentScreen()
    gridScreen.refIds = m.refIdsTask.content

    refids = m.refIdsTask.content

    currentIndex = 0
    if currentIndex < refids.count()
        gridScreen.rootChildren = []
        gridScreen.currentIndex = currentIndex
        RunRefContentTask(refids[currentIndex])
        gridScreen.currentIndex = currentIndex + 1
    end if

    m.GridScreen.SetFocus(true)
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = false
    m.refIdsTask.control = "stop"
end sub'
