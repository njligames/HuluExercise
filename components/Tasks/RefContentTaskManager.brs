
sub RunRefContentTask(refids as dynamic)
    m.refContentTask = CreateObject("roSGNode", "RefContentTask")
    m.refContentTask.ObserveField("row", "OnRefContentRowLoaded")

    m.refContentTask.refId = refids.refid
    m.refContentTask.title = refids.title

    m.refContentTask.control = "run"
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = true
end sub

sub OnRefContentRowLoaded()
    gridScreen = CurrentScreen()

    ' rootChildren = m.global.getField("rootChildren")
    rootChildren = gridScreen.rootChildren
    if m.refContentTask.row.count() > 1
        rootChildren.push(m.refContentTask.row)
        ' m.global.setField("rootChildren", rootChildren)
        gridScreen.rootChildren = rootChildren

        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        if invalid <> gridScreen then gridScreen.content = contentNode
    end if
    m.refContentTask.control = "stop"

    ' refids = m.global.getField("refids")
    refids = gridScreen.refIds
    ' currentIndex = m.global.getField("currentIndex")
    currentIndex = gridScreen.currentIndex
    if currentIndex < refids.count()
        RunRefContentTask(refids[currentIndex])
        ' m.global.setField("currentIndex", currentIndex + 1)
        gridScreen.currentIndex = currentIndex + 1
    end if
end sub
