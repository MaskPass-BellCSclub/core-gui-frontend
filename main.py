from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtQml import *
from PyQt5.QtCore import *
import cv2
from flask import Flask, Response
import time
import threading
import multiprocessing
import urllib
import json
import time

camMult = 2

flaskServer = Flask(__name__)
camera = cv2.VideoCapture(0)
img = None

def video_thread(camera):
    while True:
        global img
        ret, img = camera.read()
        
def start_flask_server():
    camThread = threading.Thread(target=video_thread, args=(camera,))
    camThread.setDaemon(True)
    camThread.start()
    flaskServer.run(host='0.0.0.0', port="5510")

@flaskServer.route('/')
def index():
    return "Camera Server Active."

def generate_frame():
    while True:
        time.sleep(0.02)
        # ret, jpg = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), 50])
        ret, jpg = cv2.imencode('.jpg', img, [int(cv2.IMWRITE_JPEG_QUALITY), 50])
        frame = jpg.tobytes()
        yield (b'--frame\r\n'
           b'Content-Type:image/jpeg\r\n'
           b'Content-Length: ' + f"{len(frame)}".encode() + b'\r\n'
           b'\r\n' + frame + b'\r\n')

@flaskServer.route('/status')
def status_check():
    global img
    if img is not None:
        return Response(status=200)
    else:
        return Response(status=503)

@flaskServer.route('/stream.mjpg')
def video_feed():
    return Response(generate_frame(), mimetype='multipart/x-mixed-replace; boundary=frame')

    
class videoThread(QThread):
    changePixmap = pyqtSignal(QImage)

    def __init__(self,_,address):
        super(videoThread,self).__init__()
        self.address = address
    
    def run(self):
        cap = cv2.VideoCapture(self.address)
        while True:
            ret, frame = cap.read()
            if ret:
                rgbImage = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                h, w, ch = rgbImage.shape
                bytesPerLine = ch * w
                convertToQtFormat = QImage(rgbImage.data, w, h, bytesPerLine, QImage.Format_RGB888)
                p = convertToQtFormat.scaled(640*camMult, 480*camMult, Qt.KeepAspectRatio)
                self.changePixmap.emit(p)


class CameraDisplayNew(QWidget):
    def __init__(self):
        super().__init__()

    @pyqtSlot(QImage)
    def setImage(self, image):
        self.label.setPixmap(QPixmap.fromImage(image))

    def initUI(self, cameraIp, statusText = None):
        self.statusText = statusText[0]
        self.setWindowTitle("AI Camera Stream")
        self.resize(1800, 1200)
        # create a label
        self.label = QLabel(self)
        # self.label.move(0,0)
        self.label.resize(640*camMult, 480*camMult)
        self.label.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.label.setAlignment(Qt.AlignCenter)
        

        self.layout = QGridLayout()
        self.layout.addWidget(self.label, 0, 0)
        self.setLayout(self.layout)
        
        th = videoThread(self, cameraIp + "/video_feed")
        th.changePixmap.connect(self.setImage)
        th.start()
        self.show()
        
    def closeEvent(self, event):
        if self.statusText:
            self.statusText[0] = "VIDEO DISPLAY: EXITED"
            self.statusText[1] = "red"
        event.accept()


class StatusUpdater(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.cameraText = ["Camera: Offline", "red", 0]
        self.aiText = ["Ai Server: Offline", "red", 0]
        self.arduinoText = ["Arduino Service: Offline", "red", 0]
        self.videoText = ["Video Display: Offline", "red", 0]
        self.readyText = ["NOT READY", "red"]

    cameraUpdated = pyqtSignal(list, arguments = ['cameraUpdater'])
    aiUpdated = pyqtSignal(list, arguments = ['aiUpdater'])
    arduinoUpdated = pyqtSignal(list, arguments = ['arduinoUpdater'])
    videoUpdated = pyqtSignal(list, arguments = ['videoUpdater'])
    readyUpdated = pyqtSignal(list, arguments = ['readyUpdater'])

    def updater(self):
        self.cameraUpdater()
        self.aiUpdater()
        self.arduinoUpdater()
        self.videoUpdater()
        self.readyUpdater()

    def cameraUpdater(self):
        self.cameraUpdated.emit(self.cameraText)

    def aiUpdater(self):
        self.aiUpdated.emit(self.aiText)

    def arduinoUpdater(self):
        self.arduinoUpdated.emit(self.arduinoText)

    def videoUpdater(self):
        self.videoUpdated.emit(self.videoText)

    def readyUpdater(self):
        self.readyUpdated.emit(self.readyText)

    def bootUp(self):
        t_thread = threading.Thread(target=self._bootUp)
        t_thread.daemon = True
        t_thread.start()

    def _bootUp(self):
        while True:
            if self.cameraText[2] * self.aiText[2] * self.arduinoText[2] * self.videoText[2] != 0:
                self.readyText = ["READY", "green"]
            else:
                self.readyText = ["NOT READY", "red"]
            self.updater()
            time.sleep(1)

    @pyqtSlot()
    def toggle_camera(self):
        self.cameraText = ["CAMERA: LOADING", "orange", 0]
        try:
            flaskThread = multiprocessing.Process(target=start_flask_server)
            flaskThread.start()
            while True:
                try:
                    with urllib.request.urlopen("http://localhost:5510/status") as url:
                        time.sleep(0.5)
                        print(url)
                        if url.status == 200:
                            break
                except Exception as e:
                    print(e)
                    
            self.cameraText = ["CAMERA: ONLINE", "green", 1]
            
        except Exception as e:
            print(e)
            self.cameraText = ["CAMERA: FAILED", "red", 0]


    @pyqtSlot(str)
    def toggle_ai(self, serverIp):
        self.aiText = ["Ai Server: Loading", "orange", 0]
        
        try:
            external_ip = urllib.request.urlopen('https://ident.me').read().decode('utf8')

            req = urllib.request.Request(serverIp + "/start_ai")
            req.add_header('Content-Type', 'application/json; charset=utf-8')
            jsondata = json.dumps({'camera': "http://" + external_ip + ":5510" + "/stream.mjpg"})
            jsondataasbytes = jsondata.encode('utf-8')   # needs to be bytes
            req.add_header('Content-Length', len(jsondataasbytes))
            
            with urllib.request.urlopen(req, jsondataasbytes) as url:
                if url.status != 200:
                    raise Exception(url.status)
                    
            self.aiText = ["Ai Server: Online", "green", 1]

        except Exception as e:
            print(e)
            self.aiText = ["Ai Server: Failed", "red", 0]

#    @pyqtSlot(str)
#    def toggle_arduino(self, serverIp):
#        self.arduinoText = ["ARDUINO SERVICE: LOADING", "orange"]
#        arduinoThread = threading.Thread(target=arduinoHandler, args=(serverIp,))
#        arduinoThread.setDaemon(True)
#        arduinoThread.start()
#        self.arduinoText = ["ARDUINO SERVICE: ONLINE", "green", 1]

    @pyqtSlot(str)
    def toggle_video(self, serverIp):
        self.aiText = ["Video Display: Loading", "orange", 0]
        self.cameraService = CameraDisplayNew()
        self.cameraService.initUI(serverIp, statusText = self.videoText)
        self.cameraService.show()
        self.aiText = ["Video Display: Online", "green", 1]

    @pyqtSlot(str)
    def stop_ai_server(self, serverIp):
        with urllib.request.urlopen(serverIp + "/stop") as url:
            pass
        self.aiText = ["Ai Server: Stopped", "red", 0]

    @pyqtSlot()
    def exit_app(self):
        global app
        global widget
        del app
        del widget
        time.sleep(1)
        sys.exit()


if __name__ == '__main__':

    import sys
    global app
    global widget

    app = QGuiApplication(sys.argv)
    widget = QApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    engine.load('./UI/control.qml')

    status_updater = StatusUpdater()
    engine.rootObjects()[0].setProperty('statusUpdater', status_updater)
    status_updater.bootUp()

    sys.exit(app.exec())