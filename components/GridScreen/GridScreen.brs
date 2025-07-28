sub Init()
    m.rowList = m.top.FindNode("rowList")
    m.rowList.SetFocus(true)
    m.focus = "rowList"
    m.descriptionLabel = m.top.FindNode("descriptionLabel")

    m.top.ObserveField("visible", "OnVisibleChange")

    m.titleLabel = m.top.FindNode("titleLabel")

    m.grid_poster = m.top.FindNode("grid_poster")
    m.grid_poster_overlay = m.top.FindNode("grid_poster_overlay")

    m.search_button = m.top.FindNode("search_button")
    m.home_button = m.top.FindNode("home_button")
    m.settings_button = m.top.FindNode("settings_button")

    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")
end sub

sub OnVisibleChange()
    if m.top.visible = true
        m.rowList.SetFocus(true)
    end if
end sub

sub OnItemFocused()
    focusedIndex = m.rowList.rowItemFocused
    row = m.rowList.content.GetChild(focusedIndex[0])
    item = row.GetChild(focusedIndex[1])

    m.grid_poster.uri = item.FHDPosterUrl
    m.grid_poster_overlay.uri = item.FHDPosterUrl
    m.titleLabel.text = item.title
end sub

function onKeyEvent(key as string, press as boolean) as boolean

    handled = false
    if press
        if key = "back"
            handled = false
        else
            if m.focus = "rowList"
                if key = "left" or key = "up"
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
                if key = "right" or key = "down"
                    m.rowList.SetFocus(true)
                    m.focus = "rowList"
                end if
            end if
            handled = true
        end if
    end if

    return handled
end function