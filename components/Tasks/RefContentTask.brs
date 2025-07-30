sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    refId = m.top.refId
    title = m.top.title
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")

    row = {}

    if invalid <> refId
        xfer.SetURL("https://cd-static.bamgrid.com/dp-117731241344/sets/" + refId + ".json")
        rsp = xfer.GetToString()

        refid_json = ParseJson(rsp)
        if invalid <> refid_json
            items = refid_json?.data?.CuratedSet?.items
            if invalid <> items
                row.title = title
                row.children = []
                for each item in items
                    itemData = GetItemData(item)
                    row.children.Push(itemData)
                end for
            end if
        end if
    end if
    m.top.row = row
end sub

function ParseImageUrl(image as object) as string
    finalUrl = "https://image.roku.com/ZHZscHItMTc2/streaming-overview.jpg"
    if invalid <> image
        url = image?.series?.default?.url
        if invalid = url then url = image?.program?.default?.url
        if invalid = url then url = image?.default?.default?.url
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
    if invalid = content then content = video?.text?.title?.full?.collection?.default?.content
    if invalid <> content then title = content

    itemContent = createObject("RoSGNode", "ContentNode")
    itemContent.HDPosterUrl = finalTileUrl
    itemContent.title = title
    itemContent.FHDPosterUrl = finalBackgroundUrl
    itemContent.SDPosterUrl = finalBackgroundDetails
    return itemContent
end function