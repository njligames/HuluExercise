
sub RunRefContentTask(refids as dynamic)
    m.refContentTask = CreateObject("roSGNode", "RefContentTask")
    m.refContentTask.ObserveField("row", "OnRefContentRowLoaded")

    m.refContentTask.refId = refids.refid
    m.refContentTask.title = refids.title

    m.refContentTask.control = "run"
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = true
end sub

sub OnRefContentRowLoaded()
    rootChildren = m.global.getField("rootChildren")
    if m.refContentTask.row.count() > 1
        rootChildren.push(m.refContentTask.row)
        m.global.setField("rootChildren", rootChildren)

        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        m.GridScreen = m.global.getField("gridscreen")
        m.GridScreen.content = contentNode
    end if
    m.refContentTask.control = "stop"

    refids = m.global.getField("refids")
    currentIndex = m.global.getField("currentIndex")
    if currentIndex < refids.count()
        RunRefContentTask(refids[currentIndex])
        m.global.setField("currentIndex", currentIndex + 1)
    end if
end sub
