sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://cd-static.bamgrid.com/dp-117731241344/home.json")
    rsp = xfer.GetToString()
    rootChildren = []

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
                            xfer.SetURL("https://cd-static.bamgrid.com/dp-117731241344/sets/" + refId + ".json")
                            rsp = xfer.GetToString()

                            refid_json = ParseJson(rsp)
                            if invalid <> refid_json
                                ' refid_title = refid_json?.data?.CuratedSet?.text?.title?.full?.set?.default?.content
                                items = refid_json?.data?.CuratedSet?.items
                                if invalid <> items
                                    row = {}
                                    row.title = title
                                    row.children = []
                                    for each item in items ' parse items and push them to row
                                        itemData = GetItemData(item)
                                        row.children.Push(itemData)
                                    end for
                                    rootChildren.Push(row)
                                end if
                            end if
                        end if
                    end if
                end if
            next
        end if
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        m.top.content = contentNode
    end if
end sub

function ParseImageUrl(image as object) as string
    finalUrl = "https://image.roku.com/ZHZscHItMTc2/streaming-overview.jpg"
    if invalid <> image
        url = image?.series?.default?.url
        if invalid = url then url = image?.program?.default?.url
        if invalid <> url then finalUrl = url
    end if
    return finalUrl
end function

function GetItemData(video as object) as object

    finalTileUrl = ParseImageUrl(video?.image?.tile?["1.78"])
    finalBackgroundUrl = ParseImageUrl(video?.image?.hero_tile?["1.78"])
    finalBackgroundDetails = ParseImageUrl(video?.image?.background_details?["1.78"])

    title = "Empty"
    content = video?.text?.title?.full?.series?.default?.content
    if invalid = content then content = video?.text?.title?.full?.program?.default?.content
    if invalid <> content then title = content

    itemContent = createObject("RoSGNode", "ContentNode")
    itemContent.HDPosterUrl = finalTileUrl
    itemContent.title = title
    itemContent.FHDPosterUrl = finalBackgroundUrl
    itemContent.SDPosterUrl = finalBackgroundDetails
    return itemContent
end function