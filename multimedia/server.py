
import tornado
from tornado.web import Application
from tornado.web import url
import subprocess


class MyFormHandler(tornado.web.RequestHandler):
    def get(self):
        self.write('<html><body><form action="/" method="POST">'
                   '<textarea name="command_box" style="width: 500; height: 500"></textarea> <br>'
                   '<input type="submit" value="Submit">'
                   '</form></body></html>')

    def post(self):
        self.set_header("Content-Type", "text/html")
        text_box = self.get_body_argument("command_box").replace("\n", " ").replace("\r", " ").replace(",", "")
        command = "python3 `pwd`/visca_control.py %s" % text_box
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
        outs, errs = process.communicate(timeout=10)
        self.write("<html><head></head><body>OK, done, result: <br> %s</body></html>" % outs.decode("utf-8").replace("\n", " <br> "))


def make_app():
    return Application([
        url(r"/", MyFormHandler),
    ])


if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
