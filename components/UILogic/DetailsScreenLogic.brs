sub ShowDetailsScreen(content as object, selectedItem as integer)
    detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    detailsScreen.content = content
    detailsScreen.jumpToItem = selectedItem
    detailsScreen.ObserveField("visible", "OnDetailsScreenVisiblityChanged")
    detailsScreen.ObserveField("buttonSelected", "OnButtonSelected")
    ShowScreen(detailsScreen)
end sub

sub OnButtonSelected(event)
    details = event.GetRoSGNode()
    content = details.content
    buttonIndex = event.getData()
    selectedItem = details.itemFocused
    if buttonIndex = 0
        ShowVideoScreen(content, selectedItem)
    end if
end sub

sub OnDetailsScreenVisiblityChanged(event as object)
    visible = event.GetData()
    detailsScreen = event.GetRoSGNode()
    if visible = false
        m.GridScreen.jumpToRowItem = [m.selectedIndex[0], detailsScreen.itemFocused]
    end if
end sub
