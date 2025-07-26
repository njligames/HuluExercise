' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of GridScreen
' Note that we need to import this file in GridScreen.xml using relative path.
sub Init()
    di = CreateObject("roDeviceInfo")

    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    m.focus = "rowList"
    ' label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")

    m.top.ObserveField("visible", "OnVisibleChange")

    ' label with item title
    m.titleLabel = m.top.FindNode("titleLabel")

    m.grid_poster = m.top.FindNode("grid_poster")

    m.search_button = m.top.FindNode("search_button")
    m.home_button = m.top.FindNode("home_button")
    m.settings_button = m.top.FindNode("settings_button")

    ' observe rowItemFocused so we can know when another item of rowList will be focused
    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")


end sub

sub OnVisibleChange()
    if m.top.visible = true
        m.rowList.SetFocus(true)
    end if
end sub

sub OnItemFocused() ' invoked when another item is focused
    focusedIndex = m.rowList.rowItemFocused ' get position of focused item
    row = m.rowList.content.GetChild(focusedIndex[0]) ' get all items of row
    item = row.GetChild(focusedIndex[1]) ' get focused item
    ' update description label with description of focused item

    m.grid_poster.uri = item.hdPosterUrl

    ' m.descriptionLabel.text = item.description
    ' update title label with title of focused item
    ' m.titleLabel.text = item.title
    ' adding length of playback to the title if item length field was populated
    ' if item.length <> invalid
    '   m.titleLabel.text += " | " + GetTime(item.length)
    ' end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    print key, press

    handled = false
    if press
        if key = "back"
            handled = false
        else
            if m.focus = "rowList"
                if key = "left"
                    m.home_button.setFocus(true)
                    m.focus = "home"
                end if
            else if m.focus = "search"
                if key = "down"
                    m.home_button.setFocus(true)
                    m.focus = "home"
                end if
                if key = "right"
                    m.rowList.SetFocus(true)
                    m.focus = "rowList"
                end if
            else if m.focus = "home"
                if key = "up"
                    m.search_button.setFocus(true)
                    m.focus = "search"
                end if
                if key = "down"
                    m.settings_button.setFocus(true)
                    m.focus = "settings"
                end if
                if key = "right"
                    m.rowList.SetFocus(true)
                    m.focus = "rowList"
                end if
            else if m.focus = "settings"
                if key = "up"
                    m.home_button.setFocus(true)
                    m.focus = "home"
                end if
                if key = "right"
                    m.rowList.SetFocus(true)
                    m.focus = "rowList"
                end if
            end if
            handled = true
        end if
    end if

    return handled
end function