import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1628
    height: 938
    flags: Qt.FramelessWindowHint | Qt.Window
    x: 120
    y: 50

    FileDialog {
        title: "打开"
        //nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
    }

    Rectangle {
        anchors.fill: parent
        z: 0
        Timer
        {
            id: disappearTimer
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                leftAirBox.visible = false
                disappearTimer.stop()
            }
        }

        Rectangle{
            id: leftAirBox
            width: rootitem.width
            height: 110
            visible: false
            color: "#ACB0AD"

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents:true

                onEntered:
                {
                    parent.visible = true;
                }

                onExited:
                {
                    disappearTimer.start()
                }

            }
        }

        //添加项
        function addItem(text, index)
        {
            var component = Qt.createComponent("ItemRect.qml");
            if (component.status === Component.Ready)
            {
              var itemrect = component.createObject(lyout);
              itemrect.text = text;
              itemrect.index = index;
              itemrect.mclicked.connect(mmclicked); //信号的关联槽函数
            }
        }

        function addSideItem(text, index)
        {
            var component = Qt.createComponent("sideRect.qml");
            if (component.status === Component.Ready)
            {
              var itemrect = component.createObject(lyout);
              itemrect.text = text;
              itemrect.showChild.connect(entrySideRect)
            }
        }

        Component.onCompleted:
        {
            addItem("精选",0)
            addItem("电影",1)
            addItem("电视剧",2)
            addItem("综艺",3)
            addItem("美少女SNH48",4)
            addItem("微电影",5)
            addItem("搞笑",6)
            addItem("纪律片",7)
            addSideItem("更多", 8)
        }

        //事件处理
        function mmclicked(index)
        {
            swipeView.currentIndex = index;
            for (var i in lyout.children)
            {
                if (lyout.children[i].index !== index)
                    lyout.children[i].clearColor();
            }
        }

        function entrySideRect(status, rect)
        {
            if (status === true)
            {
                leftAirBox.x = rect.x + rootitem.width
                leftAirBox.y = rect.y + myTitle.height
                leftAirBox.visible = true
            }
            else
            {
                leftAirBox.visible = false
            }
        }

        ColumnLayout {
            spacing: 0
            anchors.fill: parent
            MyTitle {
               id: myTitle
               Layout.fillWidth: true
               z: 2
            }

            RowLayout {
                spacing: 0
                z: 1
                Rectangle
                {
                    id : rootitem
                    height: mainWindow.height - myTitle.height
                    width: 250
                    color: "#1A1A1C"

                    ColumnLayout {
                        width: parent.width
                        height: parent.height
                        ColumnLayout{
                            id : lyout
                            anchors.top: parent.top
                            //width: parent.width
                            //height: parent.height
                            Layout.fillWidth: true
                            spacing: 0
                        }

                        Rectangle {
                            height: 46
                            width: parent.width
                            anchors.bottom: parent.bottom
                            color: "#1A1A1C"

                            GridLayout {
                               height: parent.height
                               width: parent.width
                               anchors.bottom: parent.bottom
                               anchors.bottomMargin: 8
                               anchors.left: parent.left
                               anchors.leftMargin: 28
                               anchors.right: parent.right
                               //anchors.rightMargin: 1
                               columns: 3

                               Rectangle {
                                   id: openFileButton
                                   width: 24
                                   height: 24
                                   Layout.maximumHeight: 24
                                   Layout.maximumWidth: 24
                                   color: "transparent"

                                   property string normalPath: "images/openFileN.png"              //按钮正常和鼠标离开按钮区后的图片路径
                                   property string enterPath: "images/openFileH.png"               //鼠标进入按钮区域时的图片路径
                                   property string pressPath: "images/openFileN.png"               //鼠标按下时的图片路径

                                   signal buttonClick();                    //鼠标点击时发送此信号

                                   Image {
                                       id: background
                                       anchors.fill: parent
                                       source: parent.normalPath
                                   }

                                   MouseArea {                             //处理鼠标事件
                                       anchors.fill: parent
                                       hoverEnabled: true                  //处理没有按下时的鼠标事件
                                       onClicked: fileDialog.open()          //点击按钮时发送buttonClick信号
                                       cursorShape: (containsMouse
                                                     ? (pressed
                                                     ? Qt.ArrowCursor
                                                     : Qt.PointingHandCursor)
                                                     : Qt.ArrowCursor);
                                       onEntered: background.source = parent.enterPath              //鼠标进入按钮区
                                       onPressed: background.source = parent.pressPath             //鼠标按下
                                       onExited: background.source = parent.normalPath              //鼠标离开按钮区
                                       onReleased: background.source = parent.enterPath
                                   }
                               }

                               Rectangle {
                                   id: setButton
                                   width: 25
                                   height: 25
                                   Layout.maximumHeight: 24
                                   Layout.maximumWidth: 24
                                   color: "transparent"

                                   property string normalPath: "images/setN.png"              //按钮正常和鼠标离开按钮区后的图片路径
                                   property string enterPath: "images/setH.png"               //鼠标进入按钮区域时的图片路径
                                   property string pressPath: "images/setN.png"               //鼠标按下时的图片路径

                                   signal buttonClick();                    //鼠标点击时发送此信号

                                   Image {
                                       id: setBackground
                                       anchors.fill: parent
                                       source: parent.normalPath
                                   }

                                   MouseArea {                             //处理鼠标事件
                                       anchors.fill: parent
                                       hoverEnabled: true                  //处理没有按下时的鼠标事件
                                       onClicked: parent.buttonClick()            //点击按钮时发送buttonClick信号
                                       cursorShape: (containsMouse
                                                     ? (pressed
                                                     ? Qt.ArrowCursor
                                                     : Qt.PointingHandCursor)
                                                     : Qt.ArrowCursor);
                                       onEntered: setBackground.source = parent.enterPath              //鼠标进入按钮区
                                       onPressed: setBackground.source = parent.pressPath             //鼠标按下
                                       onExited: setBackground.source = parent.normalPath              //鼠标离开按钮区
                                       onReleased: setBackground.source = parent.enterPath
                                   }
                               }

                               Rectangle {
                                   id: listButton
                                   width: 26
                                   height: 26
                                   Layout.maximumHeight: 26
                                   Layout.maximumWidth: 26
                                   color: "transparent"

                                   property string normalPath: "images/listN.png"              //按钮正常和鼠标离开按钮区后的图片路径
                                   property string enterPath: "images/listH.png"               //鼠标进入按钮区域时的图片路径
                                   property string pressPath: "images/listN.png"               //鼠标按下时的图片路径

                                   signal buttonClick();                    //鼠标点击时发送此信号

                                   Image {
                                       id: listBackground
                                       anchors.fill: parent
                                       source: parent.normalPath
                                   }

                                   MouseArea {                             //处理鼠标事件
                                       anchors.fill: parent
                                       hoverEnabled: true                  //处理没有按下时的鼠标事件
                                       onClicked: parent.buttonClick()            //点击按钮时发送buttonClick信号
                                       cursorShape: (containsMouse
                                                     ? (pressed
                                                     ? Qt.ArrowCursor
                                                     : Qt.PointingHandCursor)
                                                     : Qt.ArrowCursor);
                                       onEntered: listBackground.source = parent.enterPath              //鼠标进入按钮区
                                       onPressed: listBackground.source = parent.pressPath             //鼠标按下
                                       onExited: listBackground.source = parent.normalPath              //鼠标离开按钮区
                                       onReleased: listBackground.source = parent.enterPath
                                   }
                               }

//                               Button {
//                                   width: 24
//                                   height: 24
//                                   Layout.maximumHeight: 24
//                                   Layout.maximumWidth: 24

//                                   MouseArea {
//                                       anchors.fill: parent
//                                       //hoverEnabled: true
//                                       cursorShape: (containsMouse
//                                                     ? (pressed
//                                                        ? Qt.ClosedHandCursor
//                                                        : Qt.OpenHandCursor)
//                                                     : Qt.ArrowCursor);
//                                   }

//                                   style: ButtonStyle {
//                                       background: BorderImage {
//                                           source: control.hovered ? (control.pressed ? "images/openFileN.png" : "images/openFileH.png") : "images/openFileN.png"
//                                       }
//                                   }
//                               }

//                               Button {
//                                   width: 25
//                                   height: 25
//                                   Layout.maximumHeight: 25
//                                   Layout.maximumWidth: 25
//                                   style: ButtonStyle {
//                                       background: BorderImage {
//                                           source: control.hovered ? (control.pressed ? "images/setN.png" : "images/setH.png") : "images/setN.png"
//                                       }
//                                   }
//                               }

//                               Button {
//                                   width: 26
//                                   height: 26
//                                   Layout.maximumHeight: 26
//                                   Layout.maximumWidth: 26
//                                   style: ButtonStyle {
//                                       background: BorderImage {
//                                           source: control.hovered ? (control.pressed ? "images/listN.png" : "images/listH.png") : "images/listN.png"
//                                       }
//                                   }
//                               }
                            }
                        }
                    }

                }

                SwipeView {
                    id: swipeView
                    currentIndex: 0
                    Layout.fillWidth: true
                    Rectangle{
                        color: "#649090"
                        //anchors.fill: parent
                    }
                    Rectangle{
                        color: "green"
                        //anchors.fill: parent
                    }
                    Rectangle{
                        color: "#525AC1"
                        //anchors.fill: parent
                    }

                }
            }

        }
    }
}
