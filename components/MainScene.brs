sub Init()
    m.top.backgroundColor = "0x662D91"
    m.top.backgroundUri = "pkg:/images/background.jpg"
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    InitScreenStack()
    ShowGridScreen()
    RunContentTask()
end sub

function OnKeyEvent(key as string, press as boolean) as boolean
    result = false
    if press
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            end if
        end if
    end if
    return result
end function

sub ShowGridScreen()
    m.GridScreen = CreateObject("roSGNode", "GridScreen")
    m.GridScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelected")
    ShowScreen(m.GridScreen)
end sub

sub ShowDetailsScreen(content as object, selectedItem as integer)
    detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    detailsScreen.content = content
    detailsScreen.jumpToItem = selectedItem
    detailsScreen.ObserveField("visible", "OnDetailsScreenVisiblityChanged")
    detailsScreen.ObserveField("buttonSelected", "OnDetailsButtonSelected")
    ShowScreen(detailsScreen)
end sub

sub OnGridScreenItemSelected(event as object)
    grid = event.GetRoSGNode()
    m.selectedIndex = event.GetData()
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    itemIndex = m.selectedIndex[1]
    ShowDetailsScreen(rowContent, itemIndex)
end sub

sub OnDetailsButtonSelected(event)
    details = event.GetRoSGNode()
    content = details.content
    buttonIndex = event.getData()
    selectedItem = details.itemFocused
    if buttonIndex = 0
        ? "Play the video for item", selectedItem
    end if
end sub

sub OnDetailsScreenVisiblityChanged(event as object)
    visible = event.GetData()
    detailsScreen = event.GetRoSGNode()
    if visible = false
        m.GridScreen.jumpToRowItem = [m.selectedIndex[0], detailsScreen.itemFocused]
    end if
end sub

sub RunContentTask()
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask")
    m.contentTask.ObserveField("content", "OnMainContentLoaded")
    m.contentTask.control = "run"
    m.loadingIndicator.visible = true
end sub

sub OnMainContentLoaded()
    m.GridScreen.SetFocus(true)
    m.loadingIndicator.visible = false
    m.GridScreen.content = m.contentTask.content
end sub