import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4


ApplicationWindow {
    visible: true
    width: 300
    height: 250
    title: "Control Panel"

    ScrollView {
        anchors.fill: parent
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.interactive: true
    
        Item {
            id: gui
            anchors.fill: parent
            implicitHeight: getHeight() + 10

            function getHeight(){
                var h
                h = 0
                for (var i = 0; i < gui.children.length; i++){
                    h += gui.children[i].height
                    h += gui.children[i].anchors.topMargin
                }
                return h
            }

            Label{
                id: cctitle
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 15
                horizontalAlignment: Text.AlignHCenter
                font.family: "Courier"
                font.pointSize: 12
                text: "Control Panel"
            }


            Rectangle{
                id: headerLine
                width: parent.width-20
                height: 2
                border.color: "black"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: cctitle.bottom
                anchors.topMargin: 10
            }

            TextField{
                id: cameraServer
                width: parent.width-20
                anchors.top: headerLine.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            
                placeholderText: qsTr("Enter Camera Server")

                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 24
                    border.color: "#c7c7c7"
                    border.width: 1
                    radius: 2
                }
                font.pointSize: 10
                font.family: "Courier"
            }

            RoundButton {
                id: startCameraButton
                width: parent.width-20
                height: 35
                anchors.top: cameraServer.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                text: "Select Camera Server"
                font.family: "Courier"
                font.pointSize: 8

                scale: state === "Pressed" ? 0.96 : 1.0
                onEnabledChanged: state = ""
                signal clicked

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }

                states: [
                    State {
                        name: "Hovering"
                        PropertyChanges {
                            target: startCameraButton
                            opacity: 0.3
                        }
                    },
                    State {
                        name: "Pressed"
                        PropertyChanges {
                            target: startCameraButton
                            opacity: 1.0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""; to: "Hovering"
                        PropertyAnimation { duration: 100 }
                    },
                    Transition {
                        from: "*"; to:"Pressed" 
                        PropertyAnimation { duration: 100 }
                    }
                ]

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: startCameraButton
                    onEntered: { startCameraButton.state='Hovering'}
                    onExited: { startCameraButton.state=''}
                    onPressed: { startCameraButton.state='Pressed'}
                    onClicked: { startCameraButton.clicked();}
                    onReleased: {
                        if (containsMouse)
                        startCameraButton.state="Hovering";
                        else
                        startCameraButton.state="";
                    }
                }
                onClicked: cameraState.readOnly = true
            }

            Text{
                id: cameraState
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: startCameraButton.bottom
                anchors.topMargin: 15
                horizontalAlignment: Text.AlignLeft
                font.family: "Courier"
                font.pointSize: 10
                font.capitalization: Font.AllUppercase
                text: "Camera: Online"
                color: "green"
            }

            RoundButton {
                id: startAiButton
                width: parent.width-20
                height: 35
                anchors.top: cameraState.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                text: "Send Start Command to AI Server"
                font.family: "Courier"
                font.pointSize: 8

                
                scale: state === "Pressed" ? 0.96 : 1.0
                onEnabledChanged: state = ""
                signal clicked

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }

                states: [
                    State {
                        name: "Hovering"
                        PropertyChanges {
                            target: startAiButton
                            opacity: 0.3
                        }
                    },
                    State {
                        name: "Pressed"
                        PropertyChanges {
                            target: startAiButton
                            opacity: 1.0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""; to: "Hovering"
                        PropertyAnimation { duration: 100 }
                    },
                    Transition {
                        from: "*"; to:"Pressed" 
                        PropertyAnimation { duration: 100 }
                    }
                ]

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: startAiButton
                    onEntered: { startAiButton.state='Hovering'}
                    onExited: { startAiButton.state=''}
                    onPressed: { startAiButton.state='Pressed'}
                    onClicked: { startAiButton.clicked();}
                    onReleased: {
                        if (containsMouse)
                        startAiButton.state="Hovering";
                        else
                        startAiButton.state="";
                    }
                }
            }

            Text{
                id: aiState
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: startAiButton.bottom
                anchors.topMargin: 15
                horizontalAlignment: Text.AlignLeft
                font.family: "Courier"
                font.pointSize: 10
                font.capitalization: Font.AllUppercase
                text: "AI Server: Online"
                color: "green"
            }

            RoundButton {
                id: startArduinoButton
                width: parent.width-20
                height: 35
                anchors.top: aiState.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                text: "Send Start Command to AI Server"
                font.family: "Courier"
                font.pointSize: 8

                
                scale: state === "Pressed" ? 0.96 : 1.0
                onEnabledChanged: state = ""
                signal clicked

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }

                states: [
                    State {
                        name: "Hovering"
                        PropertyChanges {
                            target: startArduinoButton
                            opacity: 0.3
                        }
                    },
                    State {
                        name: "Pressed"
                        PropertyChanges {
                            target: startArduinoButton
                            opacity: 1.0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""; to: "Hovering"
                        PropertyAnimation { duration: 100 }
                    },
                    Transition {
                        from: "*"; to:"Pressed" 
                        PropertyAnimation { duration: 100 }
                    }
                ]

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: startArduinoButton
                    onEntered: { startArduinoButton.state='Hovering'}
                    onExited: { startArduinoButton.state=''}
                    onPressed: { startArduinoButton.state='Pressed'}
                    onClicked: { startArduinoButton.clicked();}
                    onReleased: {
                        if (containsMouse)
                        startArduinoButton.state="Hovering";
                        else
                        startArduinoButton.state="";
                    }
                }
            }

            Text{
                id: arduinoState
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: startArduinoButton.bottom
                anchors.topMargin: 15
                horizontalAlignment: Text.AlignLeft
                font.family: "Courier"
                font.pointSize: 10
                font.capitalization: Font.AllUppercase
                text: "Arduino Server: Online"
                color: "green"
            }

            RoundButton {
                id: startVideoButton
                width: parent.width-20
                height: 35
                anchors.top: arduinoState.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                text: "Start Video Service"
                font.family: "Courier"
                font.pointSize: 8

                
                scale: state === "Pressed" ? 0.96 : 1.0
                onEnabledChanged: state = ""
                signal clicked

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }

                states: [
                    State {
                        name: "Hovering"
                        PropertyChanges {
                            target: startVideoButton
                            opacity: 0.3
                        }
                    },
                    State {
                        name: "Pressed"
                        PropertyChanges {
                            target: startVideoButton
                            opacity: 1.0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""; to: "Hovering"
                        PropertyAnimation { duration: 100 }
                    },
                    Transition {
                        from: "*"; to:"Pressed" 
                        PropertyAnimation { duration: 100 }
                    }
                ]

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: startVideoButton
                    onEntered: { startVideoButton.state='Hovering'}
                    onExited: { startVideoButton.state=''}
                    onPressed: { startVideoButton.state='Pressed'}
                    onClicked: { startVideoButton.clicked();}
                    onReleased: {
                        if (containsMouse)
                        startVideoButton.state="Hovering";
                        else
                        startVideoButton.state="";
                    }
                }
            }

            Text{
                id: videoState
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: startVideoButton.bottom
                anchors.topMargin: 15
                horizontalAlignment: Text.AlignLeft
                font.family: "Courier"
                font.pointSize: 10
                font.capitalization: Font.AllUppercase
                text: "Video Display: Exited"
                color: "red"
            }

            Rectangle{
                id: exitButton
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: videoState.bottom
                anchors.topMargin: 10
                color: "red"
                Text{
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHLeft
                    font.family: "Courier"
                    font.pointSize: 10
                    text: "EXIT"
                }

                scale: state === "Pressed" ? 0.96 : 1.0
                onEnabledChanged: state = ""
                signal clicked

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }

                states: [
                    State {
                        name: "Hovering"
                        PropertyChanges {
                            target: exitButton
                            opacity: 0.5
                        }
                    },
                    State {
                        name: "Pressed"
                        PropertyChanges {
                            target: exitButton
                            opacity: 1.0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: ""; to: "Hovering"
                        PropertyAnimation { duration: 100 }
                    },
                    Transition {
                        from: "*"; to:"Pressed" 
                        PropertyAnimation { duration: 100 }
                    }
                ]

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: exitButton
                    onEntered: { exitButton.state='Hovering'}
                    onExited: { exitButton.state=''}
                    onPressed: { exitButton.state='Pressed'}
                    onClicked: { exitButton.clicked();}
                    onReleased: {
                        if (containsMouse)
                        exitButton.state="Hovering";
                        else
                        exitButton.state="";
                    }
                }
            }

            Rectangle{
                id: footerLine
                width: parent.width-20
                height: 2
                border.color: "black"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: exitButton.bottom
                anchors.topMargin: 10
            }

            Text{
                id: statusText
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: footerLine.bottom
                anchors.topMargin: 15
                horizontalAlignment: Text.AlignLeft
                font.family: "Courier"
                font.pointSize: 10
                text: "Status"
            }

            Rectangle{
                id: status
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: statusText.bottom
                anchors.topMargin: 10
                color: "red"
                Text{
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHLeft
                    font.family: "Courier"
                    font.pointSize: 10
                    text: "NOT READY"
                }
            }

        }
    }
}