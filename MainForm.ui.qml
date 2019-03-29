import QtQuick 2.8

Rectangle {
    property alias textEdit: textEdit

    width: 360
    height: 360
    property alias mouseArea: mouseArea
    property alias column: column

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        Column {
            id: column
            x: 75
            y: 85
            width: 200
            height: 400
        }
    }

    TextEdit {
        id: textEdit
        text: qsTr("Enter some text...")
        verticalAlignment: Text.AlignVCenter
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        Rectangle {
            anchors.fill: parent
            anchors.margins: -10
            color: "transparent"
            border.width: 1
        }
    }
}
