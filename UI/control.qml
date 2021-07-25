import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4


ApplicationWindow {
    visible: true
    width: 300
    height: 250
    title: "MaskPass Control Panel"

    property QtObject statusUpdater

    property string cameraText: ""
    property string cameraColor: ""

    property string aiText: ""
    property string aiColor: ""

    property string arduinoText: ""
    property string arduinoColor: ""

    property string videoText: ""
    property string videoColor: ""

    property string readyText: ""
    property string readyColor: ""

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
                text: "MaskPass Control Panel"
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
            
                placeholderText: qsTr("Enter AI/Arduino Server")
                text: "http://mc.ai1to1.com:5000"

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

                text: "Start Camera Server"
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
                text: cameraText
                color: cameraColor
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
                onClicked: {cameraServer.readOnly = true}
            }

            RoundButton {
                id: stopAiButton
                width: parent.width-20
                height: 35
                anchors.top: startAiButton.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                text: "Stop AI Server"
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
                            target: stopAiButton
                            opacity: 0.3
                        }
                    },
                    State {
                        name: "Pressed"
                        PropertyChanges {
                            target: stopAiButton
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
                    anchors.fill: stopAiButton
                    onEntered: { stopAiButton.state='Hovering'}
                    onExited: { stopAiButton.state=''}
                    onPressed: { stopAiButton.state='Pressed'}
                    onClicked: { stopAiButton.clicked();}
                    onReleased: {
                        if (containsMouse)
                        stopAiButton.state="Hovering";
                        else
                        stopAiButton.state="";
                    }
                }
                onClicked: { cameraServer.readOnly = false;}
            }

            Text{
                id: aiState
                width: parent.width-20
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: stopAiButton.bottom
                anchors.topMargin: 15
                horizontalAlignment: Text.AlignLeft
                font.family: "Courier"
                font.pointSize: 10
                font.capitalization: Font.AllUppercase
                text: aiText
                color: aiColor
            }

            RoundButton {
                id: startArduinoButton
                width: parent.width-20
                height: 35
                anchors.top: aiState.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                text: "Start Arduino Service"
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
                text: arduinoText
                color: arduinoColor
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
                text: videoText
                color: videoColor
            }

            Rectangle{
                id: exitButtonFrame

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
                            target: exitButtonFrame
                            opacity: 0.5
                        }
                    },
                    State {
                        name: "Pressed"
                        PropertyChanges {
                            target: exitButtonFrame
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
                    id: exitButton
                    hoverEnabled: true
                    anchors.fill: exitButtonFrame
                    onEntered: { exitButtonFrame.state='Hovering'}
                    onExited: { exitButtonFrame.state=''}
                    onPressed: { exitButtonFrame.state='Pressed'}
                    onClicked: { exitButtonFrame.clicked();}
                    onReleased: {
                        if (containsMouse)
                        exitButtonFrame.state="Hovering";
                        else
                        exitButtonFrame.state="";
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
                anchors.top: exitButtonFrame.bottom
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
                color: readyColor
                Text{
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHLeft
                    font.family: "Courier"
                    font.pointSize: 10
                    text: readyText
                }
            }
        }
    }


    Connections {
        target: statusUpdater
        function onStatusUpdated(status){
            cameraText = status["cameraStatus"][0]
            cameraColor = status["cameraStatus"][1]
            aiText = status["aiStatus"][0]
            aiColor = status["aiStatus"][1]
            arduinoText = status["arduinoStatus"][0]
            arduinoColor = status["arduinoStatus"][1]
            videoText = status["videoStatus"][0]
            videoColor = status["videoStatus"][1]
            readyText = status["readyStatus"][0]
            readyColor = status["readyStatus"][1]
        }
    }
    Connections {
        target: startCameraButton
        function onClicked(){
            statusUpdater.toggle_camera();
        }
    }
    Connections {
        target: startAiButton
        function onClicked(){
            statusUpdater.toggle_ai(cameraServer.displayText);
        }
    }
    Connections {
        target: startArduinoButton
        function onClicked(){
            statusUpdater.toggle_arduino(cameraServer.displayText);
        }
    }
    Connections {
        target: startVideoButton
        function onClicked(){
            statusUpdater.toggle_video(cameraServer.displayText);
        }
    }
    Connections {
        target: stopAiButton
        function onClicked(){
            statusUpdater.stop_ai_server(cameraServer.displayText);
        }
    }

    Connections {
        target: exitButton
        function onClicked(){
            statusUpdater.exit_app();
        }
    }
}