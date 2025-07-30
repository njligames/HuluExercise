
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

    rootChildren = gridScreen.rootChildren
    if m.refContentTask.row.count() > 1
        rootChildren.push(m.refContentTask.row)
        gridScreen.rootChildren = rootChildren

        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        if invalid <> gridScreen then gridScreen.content = contentNode
    end if
    m.refContentTask.control = "stop"

    ' If there are more refids, add another row.
    refids = gridScreen.refIds
    currentIndex = gridScreen.currentIndex
    if currentIndex < refids.count()
        RunRefContentTask(refids[currentIndex])
        gridScreen.currentIndex = currentIndex + 1
    end if
end sub
