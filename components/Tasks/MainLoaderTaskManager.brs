
sub RunMainLoaderTask()
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask")
    m.contentTask.ObserveField("content", "OnMainContentLoaded")
    m.contentTask.control = "run"
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = true
    print "run task"
end sub

sub OnMainContentLoaded()

    m.GridScreen = m.global.getField("gridscreen")

    m.GridScreen.SetFocus(true)
    if invalid <> m.loadingIndicator then m.loadingIndicator.visible = false
    m.GridScreen.content = m.contentTask.content
    m.contentTask.control = "stop"
    print "callback task"
end sub