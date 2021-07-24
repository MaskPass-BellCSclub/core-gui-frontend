import sys
import cv2

from PyQt5.QtGui import * #type: ignore
from PyQt5.QtQml import * #type: ignore
from PyQt5.QtCore import * #type: ignore
from PyQt5.QtWidgets import * #type: ignore
from PyQt5.QtMultimedia import * #type: ignore



if __name__=="__main__":
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    engine.load('./UI/maskCheck.qml')
    engine.load('./UI/control.qml')

    sys.exit(app.exec())