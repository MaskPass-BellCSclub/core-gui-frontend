import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 600
    height: 500
    title: "Mask Checker"

    Rectangle {
        anchors.fill: parent

        Image {
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            fillMode: Image.PreserveAspectCrop
        }

        Rectangle{
            id: maskVerifier
            anchors.fill: parent
            anchors.margins: 10
            anchors.topMargin: 7*parent.height/8
            color: "#c7c7c7"
            Text{
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Courier"
                font.pointSize: 100
                fontSizeMode: Text.Fit
                minimumPointSize: 10
                font.capitalization: Font.AllUppercase
                text: "Mask OK"
                color: "green"
            }
        }

    }
}