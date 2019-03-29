import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Rectangle
{
    id : itemrect
    width: 250;
    height: 55;
    color: "#1A1A1C"

    property string text: ""
    property int index: 0
    property bool isclicked: false
    signal mclicked(int index);  //自定义信号

    function clearColor()
    {
        color = "#1A1A1C"
        isclicked = false
    }


    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 20
        text: itemrect.text
        color: "#ACB0AD"
        font.family: "Microsoft YaHei"
        font.pixelSize: 20
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents:true

        onClicked: {
            parent.color = "#292B2D"
            mclicked(index);
            isclicked = true
        }

        onEntered:
        {
            if (!isclicked)
                parent.color = "#292B2D"
        }

        onExited:
        {
            if (!isclicked)
                parent.color = "#1A1A1C"
        }

    }
}
