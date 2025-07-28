sub Init()
    m.top.ObserveField("visible", "OnVisibleChange")
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    m.buttons = m.top.FindNode("buttons")
    m.poster = m.top.FindNode("poster")
    m.titleLabel = m.top.FindNode("titleLabel")

    result = []
    for each button in ["Play"]
        result.Push({ title: button })
    end for
    m.buttons.content = ContentListToSimpleNode(result)
end sub

sub OnVisibleChange()
    if m.top.visible = true
        m.buttons.SetFocus(true)
        m.top.itemFocused = m.top.jumpToItem
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
