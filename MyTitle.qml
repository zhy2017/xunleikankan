import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

//0c95ff
//fefdb8
Rectangle {
    id: mainTitle                       //创建标题栏
    height: 55                          //设置标题栏高度
    color: "#3c4145"                    //设置标题栏背景颜色

    property int mainWindowX
    property int mainWindowY
    property int xMouse
    property int yMouse
    property int toolNum : 0

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        property point clickPos: "0,0"
        onPressed: {
            textEdit.focus = false
            clickPos = Qt.point(mouse.x, mouse.y)
        }
        onPositionChanged: {
            //鼠标偏移量
            var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
            //如果mainwindow继承自QWidget,用setPos
            mainWindow.setX(mainWindow.x + delta.x)
            mainWindow.setY(mainWindow.y + delta.y)
        }
    }

    Window {
        id: toolTip
        visible: false
        width: toolTipLabel.text.length * 16 + 16
        height: 25
        color: "#fefdb8"
        flags: Qt.FramelessWindowHint

        Label {
            anchors.centerIn: parent
            id: toolTipLabel
            text: ""
            color: "#292B2D"
            font.family: "Microsoft YaHei"
            font.pixelSize: 16
        }
    }

    Timer
    {
        id: toolTipTimer
        interval: 500
        running: false
        repeat: true
        onTriggered: {
            if (toolNum !== 0) {
                toolTip.visible = true
                toolTipTimer.stop()
            }
        }
    }

    Rectangle {
        id: logo
        width: 32
        height: 32
        color: "transparent"

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15

        property string normalPath: "images/logo.png"              //按钮正常和鼠标离开按钮区后的图片路径
        property string enterPath: "images/logo.png"               //鼠标进入按钮区域时的图片路径
        property string pressPath: "images/logo.png"               //鼠标按下时的图片路径

        signal buttonClick();                    //鼠标点击时发送此信号

//        MyToolTip {
//            id: tooltip1
//            width: 200
//            target: logo
//            text: "Enter the text here."
//        }

        Image {
            id: background
            anchors.fill: parent
            source: parent.normalPath
        }

        MouseArea {                             //处理鼠标事件
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true         //处理没有按下时的鼠标事件
            onClicked: mouse.accepted = false         //点击按钮时发送buttonClick信号
            cursorShape: (containsMouse
                          ? (pressed
                          ? Qt.ArrowCursor
                          : Qt.PointingHandCursor)
                          : Qt.ArrowCursor);
            onEntered:
            {
                background.source = parent.enterPath              //鼠标进入按钮区
                toolTip.x = mainWindow.x + parent.x + mouseX + 12
                toolTip.y = mainWindow.y + mouseY + 25
                toolTipLabel.text = "主菜单"
                toolNum = 1
                toolTipTimer.start()
            }
            onPressed:
            {
                background.source = parent.pressPath             //鼠标按下
                mouse.accepted = false
            }
            onExited:
            {
                background.source = parent.normalPath              //鼠标离开按钮区
                toolTip.visible = false
                toolNum = 0
            }
            onReleased: background.source = parent.enterPath
        }
    }

    Rectangle {
        width: logoName.width + downImage.width
        height: logoName.height
        anchors.verticalCenter: logo.verticalCenter
        anchors.left: logo.right
        color: "transparent"

        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 3
            spacing: 0
            Label {
                id: logoName
                text: "迅雷影音"
                color: "#ACB0AD"
                font.pixelSize: 22
                font.bold: true
            }

            Image {
                id: downImage
                width: 16
                height: 16
                Layout.maximumHeight: 16
                Layout.maximumWidth: 16
                source: "images/down.png"
            }
        }

        MouseArea {                             //处理鼠标事件
            anchors.fill: parent
            hoverEnabled: true
            onClicked: mouse.accepted = false         //点击按钮时发送buttonClick信号
            cursorShape: (containsMouse
                          ? (pressed
                          ? Qt.ArrowCursor
                          : Qt.PointingHandCursor)
                          : Qt.ArrowCursor);
            onEntered:
            {
                toolTip.x = mouseX + mainWindow.x + parent.x + 12
                toolTip.y = mainWindow.y + mouseY + 25
                toolTipLabel.text = "主菜单"
                toolTipTimer.start()
                toolNum = 2
            }
            onExited:
            {
                toolTip.visible = false
                toolNum = 0
            }
        }
    }

    RowLayout {
        id: rightLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        Layout.fillWidth: true
        spacing: 10

        Rectangle {
            x: 60
            color: "#454d51"
            width: 415
            height: 35
            radius: height / 2

            Image {
                width: 35
                height: width
                visible: true
                id: searchIcon
                source: "images/search.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 6
            }

            TextField {
                width: 35
                id:textEdit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: searchIcon.right
                anchors.right: parent.right
                anchors.rightMargin: 8
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 18
                textColor:"#ACB0AD"

                focus: false

                style: TextFieldStyle {
                    background: Rectangle {
                        color: "#454d51";
                    }
                }

                Keys.enabled: true;
                Keys.onReturnPressed: {
                    textEdit.focus = false
                }

                onActiveFocusChanged: {
                    if(activeFocus) {
                        searchIcon.visible = false
                        rightSearchBtn.visible = true
                    }
                    else {
                        searchIcon.visible = true
                        rightSearchBtn.visible = false
                    }
                }
            }

            Rectangle {
                id: rightSearchBtn
                width: 35
                height: 35
                color: "transparent"
                visible: false

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 8

                property string normalPath: "images/search.png"              //按钮正常和鼠标离开按钮区后的图片路径
                property string enterPath: "images/searchH.png"               //鼠标进入按钮区域时的图片路径
                property string pressPath: "images/search.png"               //鼠标按下时的图片路径

                signal buttonClick();                    //鼠标点击时发送此信号

                Image {
                    id: rightSearchLogo
                    anchors.fill: parent
                    source: parent.normalPath
                }

                MouseArea {                             //处理鼠标事件
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                       textEdit.focus = false
                    }
                    cursorShape: (containsMouse
                                  ? (pressed
                                  ? Qt.ArrowCursor
                                  : Qt.PointingHandCursor)
                                  : Qt.ArrowCursor);
                    onEntered: rightSearchLogo.source = parent.enterPath              //鼠标进入按钮区
                    onPressed:
                    {
                        rightSearchLogo.source = parent.pressPath             //鼠标按下
                    }
                    onExited: rightSearchLogo.source = parent.normalPath              //鼠标离开按钮区
                    onReleased: rightSearchLogo.source = parent.enterPath
                }
            }
        }

        Rectangle {
            id: skinBtn
            width: 21
            height: 21
            color: "transparent"

            property string normalPath: "images/skinN.png"              //按钮正常和鼠标离开按钮区后的图片路径
            property string enterPath: "images/skinH.png"               //鼠标进入按钮区域时的图片路径
            property string pressPath: "images/skinN.png"               //鼠标按下时的图片路径

            signal buttonClick();                    //鼠标点击时发送此信号

            Image {
                id: skinImage
                anchors.fill: parent
                source: parent.normalPath
            }

            MouseArea {                             //处理鼠标事件
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                   textEdit.focus = false
                }
                cursorShape: (containsMouse
                              ? (pressed
                              ? Qt.ArrowCursor
                              : Qt.PointingHandCursor)
                              : Qt.ArrowCursor);
                onEntered: {
                    skinImage.source = parent.enterPath              //鼠标进入按钮区
                    toolTip.x = mainWindow.x + parent.x + mouseX + 12 + rightLayout.x
                    toolTip.y = mainWindow.y + mouseY + 25
                    toolTipLabel.text = "换肤"
                    toolTipTimer.start()
                    toolNum = 3
                }
                onPressed: skinImage.source = parent.pressPath             //鼠标按下
                onExited: {
                    skinImage.source = parent.normalPath              //鼠标离开按钮区
                    toolTip.visible = false
                    toolNum = 0
                }
                onReleased: skinImage.source = parent.enterPath
            }
        }

        Rectangle {
            id: hisBtn
            width: 30
            height: 30
            color: "transparent"

            property string normalPath: "images/historyN.png"              //按钮正常和鼠标离开按钮区后的图片路径
            property string enterPath: "images/historyH.png"               //鼠标进入按钮区域时的图片路径
            property string pressPath: "images/historyN.png"               //鼠标按下时的图片路径

            signal buttonClick();                    //鼠标点击时发送此信号

            Image {
                id: hisImage
                anchors.fill: parent
                source: parent.normalPath
            }

            MouseArea {                             //处理鼠标事件
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                   textEdit.focus = false
                }
                cursorShape: (containsMouse
                              ? (pressed
                              ? Qt.ArrowCursor
                              : Qt.PointingHandCursor)
                              : Qt.ArrowCursor);
                onEntered: {
                    hisImage.source = parent.enterPath
                    toolTip.x = mainWindow.x + parent.x + mouseX + 12 + rightLayout.x
                    toolTip.y = mainWindow.y + mouseY + 25
                    toolTipLabel.text = "播放记录"
                    toolTipTimer.start()
                    toolNum = 4
                }
                onPressed: hisImage.source = parent.pressPath             //鼠标按下
                onExited: {
                    hisImage.source = parent.normalPath
                    toolTip.visible = false
                    toolNum = 0
                }
                onReleased: hisImage.source = parent.enterPath
            }
        }

        Rectangle {
            id: personBtn
            width: 22
            height: 22
            color: "transparent"

            property string normalPath: "images/personN.png"              //按钮正常和鼠标离开按钮区后的图片路径
            property string enterPath: "images/personH.png"               //鼠标进入按钮区域时的图片路径
            property string pressPath: "images/personN.png"               //鼠标按下时的图片路径

            signal buttonClick();                    //鼠标点击时发送此信号

            Image {
                id: personImage
                anchors.fill: parent
                source: parent.normalPath
            }

            MouseArea {                             //处理鼠标事件
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                   textEdit.focus = false
                }
                cursorShape: (containsMouse
                              ? (pressed
                              ? Qt.ArrowCursor
                              : Qt.PointingHandCursor)
                              : Qt.ArrowCursor);
                onEntered: {
                    personImage.source = parent.enterPath
                    toolTip.x = mainWindow.x + parent.x + mouseX + 12 + rightLayout.x
                    toolTip.y = mainWindow.y + mouseY + 25
                    toolTipLabel.text = "个人中心"
                    toolTipTimer.start()
                    toolNum = 5
                }
                onPressed: personImage.source = parent.pressPath             //鼠标按下
                onExited: {
                    personImage.source = parent.normalPath
                    toolTip.visible = false
                    toolNum = 0
                }
                onReleased: personImage.source = parent.enterPath
            }
        }

        Rectangle {
            id: verLineBtn
            width: 30
            height: 30
            color: "transparent"

            property string normalPath: "images/verLineN.png"              //按钮正常和鼠标离开按钮区后的图片路径

            Image {
                id: verLineImage
                anchors.fill: parent
                source: parent.normalPath
            }
        }

        Rectangle {
            id: minBtn
            width: 35
            height: 35
            color: "transparent"

            property string normalPath: "images/minN.png"              //按钮正常和鼠标离开按钮区后的图片路径
            property string enterPath: "images/minH.png"               //鼠标进入按钮区域时的图片路径
            property string pressPath: "images/minN.png"               //鼠标按下时的图片路径

            signal buttonClick();                    //鼠标点击时发送此信号

            Image {
                id: minImage
                anchors.fill: parent
                source: parent.normalPath
            }

            MouseArea {                             //处理鼠标事件
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                   textEdit.focus = false
                }
                cursorShape: (containsMouse
                              ? (pressed
                              ? Qt.ArrowCursor
                              : Qt.PointingHandCursor)
                              : Qt.ArrowCursor);
                onEntered: {
                    minImage.source = parent.enterPath
                    toolTip.x = mainWindow.x + parent.x + mouseX + 12 + rightLayout.x
                    toolTip.y = mainWindow.y + mouseY + 25
                    toolTipLabel.text = "最小化"
                    toolTipTimer.start()
                    toolNum = 6
                }
                onPressed: minImage.source = parent.pressPath             //鼠标按下
                onExited: {
                    minImage.source = parent.normalPath
                    toolTip.visible = false
                    toolNum = 0
                }
                onReleased: minImage.source = parent.enterPath
            }
        }

        Rectangle {
            id: maxBtn
            width: 28
            height: 28
            color: "transparent"

            property string normalPath: "images/maxN.png"              //按钮正常和鼠标离开按钮区后的图片路径
            property string enterPath: "images/maxH.png"               //鼠标进入按钮区域时的图片路径
            property string pressPath: "images/maxN.png"               //鼠标按下时的图片路径

            signal buttonClick();                    //鼠标点击时发送此信号

            Image {
                id: maxImage
                anchors.fill: parent
                source: parent.normalPath
            }

            MouseArea {                             //处理鼠标事件
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                   textEdit.focus = false
                }
                cursorShape: (containsMouse
                              ? (pressed
                              ? Qt.ArrowCursor
                              : Qt.PointingHandCursor)
                              : Qt.ArrowCursor);
                onEntered: {
                    maxImage.source = parent.enterPath
                    toolTip.x = mainWindow.x + parent.x + mouseX + 12 + rightLayout.x
                    toolTip.y = mainWindow.y + mouseY + 25
                    toolTipLabel.text = "最大化"
                    toolTipTimer.start()
                    toolNum = 7
                }
                onPressed: maxImage.source = parent.pressPath             //鼠标按下
                onExited: {
                    maxImage.source = parent.normalPath
                    toolTip.visible = false
                    toolNum = 0
                }
                onReleased: maxImage.source = parent.enterPath
            }
        }

        Rectangle {
            id: closeBtn
            width: 25
            height: 25
            color: "transparent"

            property string normalPath: "images/close.png"              //按钮正常和鼠标离开按钮区后的图片路径
            property string enterPath: "images/close.png"               //鼠标进入按钮区域时的图片路径
            property string pressPath: "images/close.png"               //鼠标按下时的图片路径

            signal buttonClick();                    //鼠标点击时发送此信号

            Image {
                id: closeImage
                anchors.fill: parent
                source: parent.normalPath
            }

            MouseArea {                             //处理鼠标事件
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                   textEdit.focus = false
                }
                cursorShape: (containsMouse
                              ? (pressed
                              ? Qt.ArrowCursor
                              : Qt.PointingHandCursor)
                              : Qt.ArrowCursor);
                onEntered: {
                    closeBtn.color = "#fa3605"
                    toolTip.x = mainWindow.x + parent.x + mouseX + 12 + rightLayout.x
                    toolTip.y = mainWindow.y + mouseY + 25
                    toolTipLabel.text = "关闭"
                    toolTipTimer.start()
                    toolNum = 8
                }
                onPressed: closeBtn.color = "transparent"             //鼠标按下
                onExited: {
                    closeBtn.color = "transparent"
                    toolTip.visible = false
                    toolNum = 0
                }
                onReleased: closeBtn.color = "transparent"
            }
        }
    }
}
