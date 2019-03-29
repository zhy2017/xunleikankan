import QtQuick 2.8

Rectangle
{
    id : sideRect
    width: 250;
    height: 55;
    color: "#1A1A1C"

    property string text: ""
    property int    index: 0
    property bool   isclicked: false
    signal showChild(bool status, var rect);  //自定义信号

    function clearColor()
    {
        color = "#1A1A1C"
        isclicked = false
    }

    Text {
        id: label
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 20
        text: sideRect.text
        color: "#ACB0AD"
        font.family: "Microsoft YaHei"
        font.pixelSize: 20
    }

    Image {
        source: "images/right.png"
        anchors.left: label.right
        anchors.verticalCenter: label.verticalCenter
        anchors.leftMargin: -8
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents:true

//        onClicked: {
//            parent.color = "#292B2D"
//            mclicked(index);
//            isclicked = true
//        }

        onEntered:
        {
            parent.color = "#292B2D"
            showChild(true, sideRect)
            //childSide.visible = true
        }

        onExited:
        {
            parent.color = "#1A1A1C"
            showChild(false, sideRect)
        }

    }
}
