import Qb 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3

QbApp{
    id: appUi

    QbSettings {
        id: appSettings
        name: appUi.appTitle
        property alias lastProxy:inputProxyIp.text
    }

    QbMetaTheme{
        id: appTheme
    }

    QbRequest{
        id: requestObject
        onResultReady: {
            try{
                var jd = JSON.parse(result);
                var d =  QbCoreOne.fromBase64(jd["data"]);
                logField.append(d);
            }
            catch(e){
                logField.append(e);
            };
        }
    }

    Pane{
        id: appMainPage
        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0
        Material.background: appTheme.background
        Material.foreground: appTheme.foreground
        Material.accent: appTheme.accent
        Material.primary: appTheme.primary
        Material.theme: appTheme.theme === "dark"?Material.Dark:Material.Light
        anchors.fill: parent

        ToolBar{
            id: topToolBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: QbCoreOne.scale(50)
            Label{
                anchors.centerIn: parent
                text: appUi.appTitle
            }

            ToolButton{
                id: objExitButton
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: QbCoreOne.scale(50)
                width: height
                text: QbMF3.icon("mf-power_settings_new")
                font.family: QbMF3.family
                onClicked: {
                    appUi.close();
                }
            }
        }

        Page{
            id: contentPage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: topToolBar.bottom
            anchors.bottom: parent.bottom

            Column{
                anchors.fill: parent

                Row{
                    id: upperFields
                    anchors.leftMargin: QbCoreOne.scale(10)
                    anchors.rightMargin: QbCoreOne.scale(10)
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: QbCoreOne.scale(50)
                    spacing: QbCoreOne.scale(5)
                    TextField{
                        id: inputProxyIp
                        width: parent.width -  testButton.width - clearButton.width - QbCoreOne.scale(5)*3
                        height: parent.height
                        placeholderText: "socks5://user:pass@ip:port"
                    }
                    Button{
                        Material.background: appTheme.primary
                        id: testButton
                        text: "TEST"
                        enabled: inputProxyIp.length>0
                        onClicked: {
                            logField.append("Testing "+inputProxyIp.text);
                            logField.append("Please wait...");
                            var p = {};
                            p["headers"] = {"User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:59.0) Gecko/20100101 Firefox/59.0"};
                            p["proxy"] = inputProxyIp.text;
                            requestObject.nget("http://ip-api.com/json",p);
                        }
                    }
                    Button{
                        Material.background: appTheme.primary
                        id: clearButton
                        text: "CLEAR"
                        enabled: logField.length>0
                        onClicked: {
                            logField.text = "";
                        }
                    }
                }

                Flickable {
                    clip: true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: QbCoreOne.scale(10)
                    anchors.rightMargin: QbCoreOne.scale(10)
                    height: parent.height - upperFields.height
                    flickableDirection: Flickable.VerticalFlick
                    pixelAligned: true
                    contentHeight: logField.height
                    contentWidth: parent.width
                    TextEdit{
                        id: logField
                        readOnly: true
                        width: parent.width - QbCoreOne.scale(10)*2
                        color: appTheme.accent
                        wrapMode: TextEdit.WrapAnywhere
                    }
                }
            }
        }
    }
}
