sub Init()
    m.top.observeField("focusedChild", "onFocusChildChanged")
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    m.poster = m.top.FindNode("poster")
    m.titleLabel = m.top.FindNode("titleLabel")

    m.button = m.top.findNode("button")
    m.button.observeField("buttonSelected", "OnButtonSelected")
end sub

sub OnButtonSelected(event as object)
    print "Retrieve the data from the HuluRowListItem, the video url could be stored in it."
    print m.top.content.GetChild(m.top.jumpToItem)
end sub

sub OnFocusChildChanged(event as object)
    data = event.getData()
    if m.top.hasFocus()
        m.button.setFocus(true)
    end if
end sub

sub SetDetailsContent(content as object)
    m.poster.uri = content.fhdPosterUrl
    m.titleLabel.text = content.title
end sub

sub OnJumpToItem()
    content = m.top.content
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub

sub OnItemFocusedChanged(event as object)
    focusedItem = event.GetData()
    content = m.top.content.GetChild(focusedItem)
    SetDetailsContent(content)
end sub

function OnkeyEvent(key as string, press as boolean) as boolean
    result = false
    if press
        if key = "left"
            result = true
        else if key = "right"
            result = true
        end if
    end if
    return result
end function
