sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    m.loadRefIdData = []

    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://cd-static.bamgrid.com/dp-117731241344/home.json")
    rsp = xfer.GetToString()

    json = ParseJson(rsp)
    if invalid <> json
        containers = json?.data?.StandardCollection?.containers
        if invalid <> containers
            for each container in containers
                set = container?.set
                if invalid <> set and invalid <> set.type
                    if "SetRef" = set.type
                        refId = set?.refId
                        title = "Empty"
                        _title = set?.text?.title?.full?.set?.default?.content
                        if invalid <> _title then title = _title

                        if invalid <> refId
                            data = {
                                "refId": refId,
                                "title": title
                            }
                            m.loadRefIdData.Push(data)
                        end if
                    else if "CuratedSet" = set.type
                        ' I added this so that there will be more rows; and basically because I can....
                        ' items = set?.items
                        ' title = "Empty"
                        ' _title = set?.text?.title?.full?.set?.default?.content
                        ' if invalid <> _title then title = _title
                        ' if invalid <> items
                        '     row = {}
                        '     row.title = title
                        '     row.children = []
                        '     for each item in items
                        '         itemData = GetItemData(item)
                        '         row.children.Push(itemData)
                        '     end for
                        '     rootChildren.Push(row)
                        ' end if
                    end if
                end if
            next
        end if
    end if
    m.top.content = m.loadRefIdData
end sub