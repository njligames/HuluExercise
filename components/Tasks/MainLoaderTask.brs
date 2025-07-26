' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
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
                        title = set?.text?.title?.full?.set?.default?.content

                        if invalid <> refId
                            xfer.SetURL("https://cd-static.bamgrid.com/dp-117731241344/sets/" + refId + ".json")
                            rsp = xfer.GetToString()

                            refid_json = ParseJson(rsp)
                            if invalid <> refid_json
                                refid_title = refid_json?.data?.CuratedSet?.text?.title?.full?.set?.default?.content
                                items = refid_json?.data?.CuratedSet?.items
                                if invalid <> items and invalid <> refid_title
                                    ?refid_title


                                    row = {}
                                    row.title = refid_title
                                    row.children = []
                                    for each item in items ' parse items and push them to row
                                        itemData = GetItemData(item)
                                        row.children.Push(itemData)
                                    end for
                                    rootChildren.Push(row)



                                    ' for each item in items
                                    '     ?item
                                    ' next
                                end if
                            end if
                        end if



                    end if
                end if
            next
        end if
        ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        ' populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = contentNode
    end if
end sub

sub GetContent2()
    ' request the content feed from the API
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://jonathanbduval.com/roku/feeds/roku-developers-feed-v1.json")
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}

    ' parse the feed and build a tree of ContentNodes to populate the GridView
    json = ParseJson(rsp)
    if json <> invalid
        for each category in json
            value = json.Lookup(category)
            if Type(value) = "roArray" ' if parsed key value having other objects in it
                if category <> "series" ' ignore series for this phase
                    row = {}
                    row.title = category
                    row.children = []
                    for each item in value ' parse items and push them to row
                        itemData = GetItemData2(item)
                        row.children.Push(itemData)
                    end for
                    rootChildren.Push(row)
                end if
            end if
        end for
        ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        ' populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = contentNode
    end if
end sub

function GetItemData(video as object) as object

    finalTileUrl = "https://image.roku.com/ZHZscHItMTc2/streaming-overview.jpg"
    ratio = video?.image?.tile["1.78"]
    if invalid <> ratio
        url = ratio?.series?.default?.url
        if invalid = url
            url = ratio?.program?.default?.url
        end if
    end if
    if invalid <> url then finalTileUrl = url

    title = "Empty"
    content = video?.text?.title?.full?.series?.default?.content
    if invalid = content
        content = video?.text?.title?.full?.program?.default?.content
    end if
    if invalid <> content then title = content

    itemContent = createObject("RoSGNode", "ContentNode")
    itemContent.HDPosterUrl = finalTileUrl
    itemContent.title = title
    return itemContent
end function

function GetItemData2(video as object) as object
    item = {}
    ' populate some standard content metadata fields to be displayed on the GridScreen
    ' https://developer.roku.com/docs/developer-program/getting-started/architecture/content-metadata.md
    ' if video.longDescription <> invalid
    '     item.description = video.longDescription
    ' else
    '     item.description = video.shortDescription
    ' end if
    stop
    item.hdPosterURL = video.thumbnail
    ' item.title = video.title
    ' item.releaseDate = video.releaseDate
    ' item.id = video.id
    ' if video.content <> invalid
    '     ' populate length of content to be displayed on the GridScreen
    '     item.length = video.content.duration
    ' end if
    return item
end function