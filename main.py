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
import serial

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

#======================================
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

#======================================
class CameraDisplayNew(QWidget):
    def __init__(self):
        super().__init__()
        self.statusText = []

    @pyqtSlot(QImage)
    def setImage(self, image):
        self.label.setPixmap(QPixmap.fromImage(image))

    def initUI(self, cameraIp, statusText = None):
        self.statusText = statusText
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
        self.statusText[0] = "Video Display: Exited"
        self.statusText[1] = "red"
        self.statusText[2] = 0
        event.accept()

#======================================
class StatusUpdater(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.serviceStatus = {
            "cameraStatus": ["Camera: Offline", "red", 0],
            "aiStatus": ["Ai Server: Offline", "red", 0],
            "arduinoStatus": ["Arduino Service: Offline", "red", 0],
            "videoStatus": ["Video Display: Offline", "red", 0],
            "readyStatus": ["NOT READY", "red"]
        }

    statusUpdated = pyqtSignal(QVariant, arguments = ['statusUpdater'])

    def statusUpdater(self):
        self.statusUpdated.emit(self.serviceStatus)

    def bootUp(self):
        t_thread = threading.Thread(target=self._bootUp)
        t_thread.daemon = True
        t_thread.start()

    def _bootUp(self):
        while True:
            if (self.serviceStatus["cameraStatus"][2] * self.serviceStatus["aiStatus"][2] * self.serviceStatus["arduinoStatus"][2] * self.serviceStatus["videoStatus"][2]) != 0:
                self.serviceStatus["readyStatus"] = ["READY", "green"]
            else:
                self.serviceStatus["readyStatus"] = ["NOT READY", "red"]
            self.statusUpdater()
            time.sleep(1)

    @pyqtSlot()
    def toggle_camera(self):
        self.serviceStatus["cameraStatus"] = ["CAMERA: LOADING", "orange", 0]
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
                    
            self.serviceStatus["cameraStatus"] = ["CAMERA: ONLINE", "green", 1]
            
        except Exception as e:
            print(e)
            self.serviceStatus["cameraStatus"] = ["CAMERA: FAILED", "red", 0]


    @pyqtSlot(str)
    def toggle_ai(self, serverIp):
        self.serviceStatus["aiStatus"] = ["Ai Server: Loading", "orange", 0]
        
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
                    
            self.serviceStatus["aiStatus"] = ["Ai Server: Online", "green", 1]

        except Exception as e:
            print(e)
            self.serviceStatus["aiStatus"] = ["Ai Server: Failed", "red", 0]

    @pyqtSlot(str)
    def toggle_arduino(self, serverIp):
        self.serviceStatus["arduinoStatus"] = ["ARDUINO SERVICE: LOADING", "orange", 0]
        arduinoThread = threading.Thread(target=arduinoHandler, args=(serverIp, self.serviceStatus["arduinoStatus"]))
        arduinoThread.setDaemon(True)
        arduinoThread.start()

    @pyqtSlot(str)
    def toggle_video(self, serverIp):
        self.serviceStatus["videoStatus"] = ["Video Display: Loading", "orange", 0]
        self.cameraService = CameraDisplayNew()
        self.cameraService.initUI(serverIp, statusText = self.serviceStatus["videoStatus"])
        self.cameraService.show()
        self.serviceStatus["videoStatus"] = ["Video Display: Online", "green", 1]

    @pyqtSlot(str)
    def stop_ai_server(self, serverIp):
        if self.serviceStatus["aiStatus"][2] == 1:
            with urllib.request.urlopen(serverIp + "/stop") as url:
                pass
        self.serviceStatus["aiStatus"] = ["Ai Server: Stopped", "red", 0]

    @pyqtSlot()
    def exit_app(self):
        global app
        global widget
        del app
        del widget
        time.sleep(1)
        sys.exit()

#======================================

def sendToArduino(sendStr):
    global ser
    ser.write(sendStr.encode('utf-8'))

def recieveFromArduino():
    global ser
    global startMarker, endMarker

    ck = ""
    x = "z"
    byteCount = -1 

    while  ord(x) != startMarker: 
        x = ser.read()

    while ord(x) != endMarker:
        if ord(x) != startMarker:
            ck = ck + x.decode("utf-8")
            byteCount += 1
        x = ser.read()

    return(ck)

def waitForArduino():

    global ser
    global startMarker, endMarker

    msg = ""
    while msg.find("Arduino is ready") == -1:

        while ser.inWaiting() == 0:
            pass

        msg = recieveFromArduino()

        print (msg)
        print ()

def arduino_open_door(myI):
    waitingForReply = False
    if waitingForReply == False:

        sendToArduino(myI)
        waitingForReply = True

        if waitingForReply == True:

            while ser.inWaiting() == 0:
                pass

            dataRecieved = recieveFromArduino()
            waitingForReply = False

        time.sleep(5)

def arduino_close_door(myI):
    waitingForReply = False
    if waitingForReply == False:
        sendToArduino(myI)
        waitingForReply = True

        if waitingForReply == True:

            while ser.inWaiting() == 0:
                pass

            dataRecieved = recieveFromArduino()
            waitingForReply = False

        time.sleep(5)

def arduinoHandler(serverIp, arduinoStatus):
    import serial
    global startMarker, endMarker, ser
    startMarker = 60
    endMarker = 62
    serPort = "COM8"
    baudRate = 9600
    try:
        ser = serial.Serial(serPort, baudRate)
    except Exception as e:
        #arduinoStatus = ["Arduino Server: Failed", "red", 0]
        arduinoStatus[0] = "Arduino Service: Failed"
        arduinoStatus[1] = "red"
        arduinoStatus[2] = 0
        print(e) 

    while True:
        try:
            time.sleep(1)
            with urllib.request.urlopen(serverIp + "/open_door") as url:
                if arduinoStatus[2] != 1:
                    arduinoStatus[0] = "Arduino Service: Online"
                    arduinoStatus[1] = "green"
                    arduinoStatus[2] = 1
                if url.status == 200:
                    res = url.read().decode('utf-8')
                    if res == "True":
                        arduino_open_door(0)
                        time.sleep(5)
                        arduino_close_door(1)
                    else:
                        pass
                else:
                    raise Exception(url.status)
        except Exception as e:
            arduinoStatus[0] = "Arduino Service: Failed"
            arduinoStatus[1] = "red"
            arduinoStatus[2] = 0
            print(e)

#======================================

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